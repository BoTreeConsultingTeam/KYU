module Gioco_Methods
  extend ActiveSupport::Concern
  included do
    def change_points(options)
      if Gioco::Core::KINDS
        points = options[:points]
        kind   = Kind.find(options[:kind])
      else
        points = options
        kind   = false
      end
      present_badge_kind(points,kind)
      new_pontuation = @old_pontuation + points
      Gioco::Core.sync_resource_by_points(self, new_pontuation, kind)
    end

    def next_badge?(kind_id = false)
      present_badge_kind(points,kind)
      next_badge       = Badge.where("points > #{old_pontuation}").order("points ASC").first
      last_badge_point = self.badges.last.try('points')
      last_badge_point ||= 0

      if next_badge
        percentage      = (old_pontuation - last_badge_point)*100/(next_badge.points - last_badge_point)
        points          = next_badge.points - old_pontuation
        next_badge_info = {
                            :badge      => next_badge,
                            :points     => points,
                            :percentage => percentage
                          }
      end
    end

    def add(resource_id)
      resource = Gioco::Core.get_resource(resource_id)
      if Gioco::Core::POINTS && !resource.badges.include?(self)
        if Gioco::Core::KINDS
           sync_resource_by_points resoure, self.points, self.kind
        else
          sync_resource_by_points resoure, self.points 
        end
      elsif !resource.badges.include?(self)
        resource.badges << self
        return self
      end
    end

    def remove(resource_id)
      resource = Gioco::Core.get_resource(resource_id)

      if Gioco::Core::POINTS && resource.badges.include?(self)
        if Gioco::Core::KINDS
          kind       = self.kind
          points_kind = "points < #{self.points} AND kind_id = #{kind.id}" 
          badges_gap = Badge.where(points_kind).order('points DESC')[0]
          sync_resource_by_points resoure, badges_gap,kind
        else
          points_kind = "points < #{self.points}" 
          badges_gap = Badge.where(points_kind).order('points DESC')[0]
          sync_resource_by_points resoure, badges_gap,kind = nil
        end
      elsif resource.badges.include?(self)
        resource.levels.where( :badge_id => self.id )[0].destroy
        return self
      end
    end
    private

    def present_badge_kind(points, kind)
      if Gioco::Core::KINDS
        raise "Missing Kind Identifier argument" if !kind_id
        @old_pontuation = self.points.where(:kind_id => kind_id).sum(:value)
      else
        @old_pontuation = self.points.to_i
      end
    end

    def sync_resource_by_points resoure, badges_gap,kind = nil
      Gioco::Core.sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points, kind)
    end
  end
end
