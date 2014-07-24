class Role < ActiveRecord::Base
  OPERATOR = 'operator'
  ADMINISTRATOR = 'administrator'
  TEACHER = 'teacher'
  STUDENT = 'student'

  has_many :user_roles
  has_many :users, through: :user_roles

  scope :operator, where(role_alias: OPERATOR)
  scope :administrator, where(role_alias: ADMINISTRATOR)
  scope :teacher, where(role_alias: TEACHER)
  scope :student, where(role_alias: STUDENT)

  class << self
    def role_operator
      operator.first if operator
    end

    def role_administrator
      administrator.first if administrator
    end

    def role_teacher
      teacher.first if teacher
    end

    def role_student
      student.first if student
    end
  end
end
