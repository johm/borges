class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
      # Always performed
      can :access, :ckeditor   # needed to access Ckeditor filebrowser

      # Performed checks for actions:
      can [:read, :create, :destroy], Ckeditor::Picture
      can [:read, :create, :destroy], Ckeditor::AttachmentFile
    else
      if user.has_role? :scheduler 
        can :manage, Event
        can :manage, EventLocation
        can :manage, EventStaffer
        can :manage_calendar, :dashboard
      end
      if user.has_role? :checkcalendar
        can :read, Event
        can :manage_calendar, :dashboard
      end
      can :read, Title 
      can :read, Edition
      can :read, Author
      can :read, Image
      can :read, Publisher
      can :read, Page, :published => true
      can :read, TitleList, :public => true
      can :read, Post, :published => true
      can :read, PostCategory
      can :read, Category
      can [:read,:calendar,:twentysixforty], Event
      can :read, EventLocation
      can [:update,:destroy], ShoppingCartLineItem #further checks in controller!

      if !user.id.blank?  # guests can't create shopping carts 
        can :create, SaleOrder
        can :update, SaleOrder, :user_id => user.id
        can [:create,:update], SaleOrderLineItem, :sale_order => {:user_id => user.id}
      end
      

    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
