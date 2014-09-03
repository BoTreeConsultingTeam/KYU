class Impression < ActiveRecord::Base
	attr_accessible :impressionable_id, :impressionable_type, :ip_address, :user_id
	belongs_to :impressionable, :polymorphic=>true


	#default_scope order("created_at DESC")
	#scope :recent_data_view, -> { where("impressionable_type = ?", 'Question').group('impressionable_type, impressionable_id').order('impressionable_id desc').limit(3)}

end	