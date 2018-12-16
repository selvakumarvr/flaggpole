class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :line1, :line2, :logo_url
  has_many :organization_links

  def logo_url
  	logo = object.logo.url(:medium)
  	"http://twitzip.com#{logo}"
  end
end
