# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return unless user.persisted?

    if user.admin?
      can :read, ActiveAdmin::Page, namespace_name: :admin
      can :manage, :all
      cannot :update, [User, Review]
      can :update, User, id: user.id
    end
    can :create, Review
    can %i[index show], Order, user_id: user.id
  end
end
