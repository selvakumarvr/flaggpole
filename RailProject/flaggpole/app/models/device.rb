class Device < ActiveRecord::Base
  #attr_accessible :token, :badge
  # strong_parameters
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :user
  validates :token,
    :presence => true,
    :uniqueness => true,
    :format => { :with => /[[:xdigit:]]{40}/, :message => "Invalid device token" }

  before_validation :normalize_token!

  protected

  def normalize_token!
      self.token = self.token.strip.gsub(/[<\s>]/, '')
  end
end
