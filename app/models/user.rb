class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, through: :user_roles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :salutation, :first_name, :middle_name, :last_name, :email, :date_of_birth

  def is_admin?
    return true if have_role?(Role::ADMINISTRATOR)
    false
  end

  def is_operator?
    return true if have_role?(Role::OPERATOR)
    false
  end

  def is_teacher?
    return true if have_role?(Role::TEACHER)
    false
  end

  def have_role?(role_type)
    return roles.pluck(:role_alias).include? role_type if roles
    false
  end

  def new_user_account_notification(password)
    begin
      KyuMailer.new_user_account_notification(self, password).deliver
    rescue Exception => e
      Rails.logger.error "Failed to send email, email address: #{self.email}"
      Rails.logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
    end
  end
end
