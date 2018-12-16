class FollowFollowersJob < Struct.new(:twitter_zip_id)
  def perform
    twitter_zip = TwitterZip.find(twitter_zip_id)
    twitter_zip.follow_followers
  end
end
