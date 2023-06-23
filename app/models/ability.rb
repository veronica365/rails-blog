# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Check logged in or guest user
    user ||= User.new

    # additional permissions for administrators
    return can :manage, :all if user.role == 'admin'
    
    # additional permissions for logged in users      
    can :create, Post, author: user
    can :create, Comment, author: user
    can :create, Like, author: user
    
    can :destroy, Post do | post |
      post.author == user
    end
    can :destroy, Comment do | comment |
      comment.author == user
    end

    # No permissions for other users
    can :read, :all
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
