class Tagging < ActsAsTaggableOn
before_save :set_tag_owner
def set_tag_owner
    # Set the owner of some tags based on the current tag_list
    set_owner_tag_list_on(account, :tags, self.tag_list)
    # Clear the list so we don't get duplicate taggings
    tag_list = nil
 end
end