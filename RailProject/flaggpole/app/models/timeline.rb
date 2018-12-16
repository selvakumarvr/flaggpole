class Timeline
  include ActiveModel::SerializerSupport

  attr_accessor :subscriptions

  def initialize(subscriptions)
    self.subscriptions = subscriptions
    @twitter_zips = self.subscriptions.select{|x| x.subscribable_type == 'TwitterZip'}.map(&:subscribable)
    @zips = @twitter_zips.map(&:zip)
    @organizations = self.subscriptions.select{|x| x.subscribable_type == 'Organization'}.map(&:subscribable)
  end

  # TODO accept a since parameter to get all alerts/zip_messages/organization_message since a specified date
  def alerts
    Alert.includes(
      :infos => [
        :event_codes,
        :parameters,
        :resources,
        {:areas => [:geocodes, :circles, :polygons]}
      ]
    ).joins(:twitter_zips).where(twitter_zips: {id: @twitter_zips}).order("created_at DESC").limit(10)
  end

  def zip_messages
    ZipMessage.where(zip: @zips).where('source_id NOT IN (?)', alert_sources).order('created_at DESC').limit(10)
  end

  def organization_messages
    OrganizationMessage.joins(:author => :organization).where('organizations.id IN (?)', @organizations)
      .order('created_at DESC').limit(10)
  end

  def alert_sources
    [Source.index('FEMA'), Source.index('NOAA')]
  end

  def persisted?
    false
  end
end
