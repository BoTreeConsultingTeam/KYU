module Findable
	extend ActiveSupport::Concern
	included do
		default_scope order("created_at DESC")
	end
end