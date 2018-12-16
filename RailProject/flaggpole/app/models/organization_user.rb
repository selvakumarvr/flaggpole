class OrganizationUser < ActiveRecord::Base
  belongs_to :organization
  has_many :messages, :class_name => 'OrganizationMessage'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # make admin accessible but protect with strong_parameters
  attr_accessible :email, :password, :password_confirmation, :remember_me, :organization_id, :current_password

  # strong_parameters
  include ActiveModel::ForbiddenAttributesProtection
end
