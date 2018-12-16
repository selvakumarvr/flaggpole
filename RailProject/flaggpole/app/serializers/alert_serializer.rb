class AlertSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :sent, :status, :msg_type, :source, :short_url, :twitzip_url
  has_many :infos

  def twitzip_url
    object.twitzip_url + '?app=1'
  end
end
