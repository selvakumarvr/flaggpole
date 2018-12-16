class OrganizationMessageSerializer < ActiveModel::Serializer
  attributes :organization, :message

  def organization
  	object.author.organization.name
  end
end
