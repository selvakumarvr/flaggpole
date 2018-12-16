class DirectMessageFollowersJob < Struct.new(:twitter_zip_id, :message)
  def perform
    twitter_zip = TwitterZip.find(twitter_zip_id)
    twitter_zip.direct_message_followers(message)
  end
end
