class TweetZipMessagesForAlertJob < Struct.new(:alert_id)
  def perform
    alert = Alert.find alert_id
    zips = alert.twitter_zips.map(&:zip)
    zip_messages = ZipMessage.not_tweeted.where(:zip => zips).where(:source_id => [FemaIpaws::SOURCE, NoaaAlerts::SOURCE])

    puts "Tweeting #{zip_messages.count} tweets for alert #{alert.id}"
    zip_messages.each do |zm|
      zm.tweet
      zm.update_attributes(:enqueued => false)
    end
  end
end
