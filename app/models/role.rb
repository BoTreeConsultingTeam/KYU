class Role < ActiveRecord::Base
  OPERATOR = 'operator'
  ADMINISTRATOR = 'administrator'
  TEACHER = 'teacher'
  STUDENT = 'student'

  scope :operator, where(role_alias: OPERATOR)
  scope :administrator, where(role_alias: ADMINISTRATOR)
  scope :teacher, where(role_alias: TEACHER)
  scope :student, where(role_alias: STUDENT)

  class << self
    def operator
      operator.first if operator
    end

    def administrator
      administrator.first if administrator
    end

    def teacher
      teacher.first if teacher
    end

    def student
      student.first if student
    end
  end
end
