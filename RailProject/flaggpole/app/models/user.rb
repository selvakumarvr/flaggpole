class User < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :twitter_zips, :through => :subscriptions, :source => :subscribable, :source_type => 'TwitterZip'
  has_many :organizations, :through => :subscriptions, :source => :subscribable, :source_type => 'Organization'
  has_many :devices

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :zip, :remember_me

  validates :zip, :presence => true
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be in the form 12345"

  def subscribables
    self.twitter_zips + self.organizations
  end

  def subscribe_to_zip(zip)
    tz = TwitterZip.find_by_zip(zip)
    subscribed = tz && self.twitter_zips.include?(tz)
    can_subscribe = tz && !subscribed
    self.subscriptions.create!(subscribable_type: 'TwitterZip', subscribable_id: tz.id, home: true) if can_subscribe
  end

end
