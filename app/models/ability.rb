class Ability
  include CanCan::Ability

  def initialize(user)
    if user.class.to_s == 'Teacher'
      can :manage, [Answer,Comment]
      can :read, Question
      can :view, [Question,Answer,Comment]
    else
      can :edit, Question
      can :edit, Answer
      can :new, Question
    end
  end
end
