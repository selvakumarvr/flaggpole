class User < ActiveRecord::Base

  has_many :authorized_ncms, :foreign_key => :manager_id, :class_name => "Ncm"
  has_many :csv_exports
  has_many :ncm_data_files
  has_many :pdf_exports
  has_many :permissions
  has_many :time_entries

  belongs_to :customer
  belongs_to :location

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :level, :customer_id, :location_id

  # Roles
  %w(volcanic master_admin pqsi_employee pqsi_data_entry customer_manager customer_location_manager).each do |role|
    class_eval <<-EVAL, __FILE__, __LINE__ + 1
      #{role.upcase} = "#{role}"
      scope :#{role.pluralize}, where(:level => :#{role})

      def is_#{role}?
        @is_#{role} = (level == #{role.upcase})
      end
    EVAL
  end

  def name
    [self.first_name, self.last_name].join(" ")
    # self.first_name.to_s + " " + self.last_name.to_s
  end

  def is_customer?
    @is_customer ||= (level == "customer_manager" || level == "customer_location_manager")
  end

  def is_admin?
    @is_admin ||= (level == "volcanic" || level == "master_admin")
  end

  def authorized_locations
    if self.is_customer_manager?
      @locations = self.customer.locations.order("name")
    elsif self.is_customer_location_manager?
      @locations = self.customer.locations.where(:id => self.location)
    elsif self.is_pqsi_data_entry?
      @locations = Location.where(:id => (Permission.permissionable_ids(self.permissions.location_permissions)))
    else
      @locations = Location.includes(:customer).where("customers.id IS NOT NULL").order("locations.name").scoped
    end

    @locations
  end

  def authroized_customers
    if self.is_pqsi_employee? || self.is_volcanic? || self.is_master_admin?
      @customers = Customer.order("name").scoped
    elsif self.is_pqsi_data_entry?
      @customers = Customer.scoped.where(:id => self.authorized_ncms.select("customer_id").map{|ncm| ncm.customer_id })
    elsif self.is_customer?
      @customers = Customer.scoped.where(:id => self.customer_id)
    end
  end

  def authorized_ncms
    if self.is_customer_manager?
      @ncms = self.customer.ncms.scoped
    elsif self.is_customer_location_manager? || self.is_pqsi_data_entry?
      @ncm_ids = Permission.permissionable_ids(self.permissions.ncm_permissions)
      @location_ids = Permission.permissionable_ids(self.permissions.location_permissions)
      t = Ncm.arel_table
      @ncms = Ncm.where( t[:id].in(@ncm_ids).or(t[:location_id].in(@location_ids) ) )
    elsif self.is_volcanic? || self.is_pqsi_employee? || self.is_master_admin?
      @ncms = Ncm.scoped
    end

    @ncms
  end

  def authorized_ncm_ids
    @ncms = authorized_ncms
    @ncms.select('id').map {|n| n.id }
  end

  def authorized_location_ids
    @ncms = authorized_locations
    @ncms.select('id').map {|n| n.id }
  end


  protected
    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end


end
