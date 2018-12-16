class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :subscribable_type, :home
  has_one :subscribable
end
