module Taggable
  extend ActiveSupport::Concern
  included do
    has_many :taggings
    has_many :tags, through: :taggings, dependent: :destroy
  end
end

