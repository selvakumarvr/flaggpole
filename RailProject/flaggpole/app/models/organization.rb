require 'zlib'

class Organization < ActiveRecord::Base
  attr_accessible :name, :line1, :line2, :logo, :nces_id, :district_nces_id, 
    :delete_logo, :organization_links_attributes

  has_attached_file :logo,
  	:styles => {
  		:medium => "300x300>",
  		:thumb => "100x100>"
  	},
  	:default_url => "/assets/missing_:style.png"

	attr_accessor :delete_logo
  before_validation { logo.clear if delete_logo == '1' }

  has_many :subscriptions, :as => :subscribable, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user
  has_many :users, :class_name => 'OrganizationUser', :dependent => :destroy
  has_many :messages, :through => :users, :source => :organization_messages
  has_many :organization_links, :dependent => :destroy
  accepts_nested_attributes_for :organization_links,
    :reject_if => lambda { |a| a[:url].blank? },
    :allow_destroy => true

  validates_uniqueness_of :name, :message => 'already exists as an organization'

  def self.export_json_pretty
    path = File.join([Rails.root, "public", "organizations.json"])
    File.open(path, "w") do |f|
      f.write JSON.pretty_generate(JSON.parse(Organization.select([:id, :name, :district_nces_id, :nces_id]).all.to_json))
    end
  end

  def self.export_json
    path = File.join([Rails.root, "public", "organizations.json"])
    File.open(path, "w") do |f|
      f.write Organization.select([:id, :name, :district_nces_id, :nces_id]).all.to_json
      #f.write ActiveModel::ArraySerializer.new(
      #  Organization.select([:id, :name, :district_nces_id, :nces_id]).all,
      #  each_serializer: SimpleOrganizationSerializer
      #).to_json
    end

    # write gziped file
    gz_path = File.join([Rails.root, "public", "organizations.json.gz"])
    gz = Zlib::GzipWriter.new(File.open(gz_path, "wb"))
    gz.write File.read(path)
    gz.close
  end

end
