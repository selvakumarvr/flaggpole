class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_volcanic? || user.is_master_admin? || user.is_pqsi_employee?
      can :manage, :all
    end

    if user.is_pqsi_data_entry?
      can [:read, :create, :edit], Ncm, :id => user.authorized_ncm_ids
      can :manage, TimeEntry, :ncm => { :id => user.authorized_ncm_ids }
      can :manage, User, :id => user.id
      can [:create, :read, :edit], Scan
    end

    if user.is_customer_manager?
      # can :manage, Customer
      can :read, Ncm, :customer => { :id => user.authorized_ncm_ids }
      can :manage, User, :id => user.id
    end

    if user.is_customer_location_manager?
      can :manage, Location
      can :manage, User, :id => user.id
      can :read, Ncm, :id => user.authorized_ncm_ids
    end

    can :read, CsvExport, :user => { :id => user.id }
    can :read, PdfExport, :user => { :id => user.id }
    # can :read, :all
  end
end
