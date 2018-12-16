class ZipMessageSerializer < ActiveModel::Serializer
  attributes :content, :created_at, :id, :source, :uid, :zip

  def source
    object.source
  end
end
