class Subscription < ActiveRecord::Base
  attr_accessible :subscribable_id, :subscribable_type, :home

  belongs_to :user
  belongs_to :subscribable, :polymorphic => true

  validates :user_id, :presence => true
  #validates :subscribable, :presence => {message: "item does not exist"}
  validate :valid_subscribable
  validates_uniqueness_of :subscribable_id, :scope => [:user_id, :subscribable_type],
    :message => 'you are already subscribed'

  def valid_subscribable
    if self.subscribable_id.nil?
      errors[:base] << "ZIP does not exist" if subscribable_type == 'TwitterZip'
      errors[:base] << "Organization does not exist" if subscribable_type == 'Organization'
    end
  end

  def self.remove_home(user, subscribable_type)
    # set home to false for all subscriptions of this type
    Subscription.update_all({:home => false}, {:user_id => user.id, :subscribable_type => subscribable_type})
  end

end
