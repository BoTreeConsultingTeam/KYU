class ApplicationController < ActionController::Base
  helper_method :resource, :resource_name, :devise_mapping
  protect_from_forgery with: :exception

  protected

  def after_sign_in_path_for(resource)
    current_user.present? ? admin_index_path : root_path
  end

  private

  def require_admin
    msg = (current_user.is_admin? ? '' : t('permissions.admin_rights_required'))
    access_denied_redirect(msg)
  end

  def require_operator
    msg = (current_user.is_operator? ? '' : t('permissions.operator_rights_required'))
    access_denied_redirect(msg)
  end

  def require_teacher
    msg = (current_user.is_teacher? ? '' : t('permissions.teacher_rights_required'))
    access_denied_redirect(msg)
  end

  def require_student
    msg = (current_user.is_student? ? '' : t('permissions.student_rights_required'))
    access_denied_redirect(msg)
  end

  def access_denied_redirect(msg)
    if msg.present?
      redirect_to root_path, flash: { error: msg }
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
