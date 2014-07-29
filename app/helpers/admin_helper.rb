module AdminHelper
  def roles_dropdown(roles, selected=nil)
    # The title attribute value is used to load on Add/Edit Operator/Teacher
    options = roles.collect do |role|
                [role.name, role.id]
              end

    select_tag("user_role[role_id]", options_for_select(options, selected), prompt: t('registration.caption.role_select_prompt'), class: 'form-control')
  end
end
