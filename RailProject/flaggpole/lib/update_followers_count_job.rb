class UpdateFollowersCountJob < Struct.new(:screen_names)
  def perform
    TwitterZip.update_followers_count(screen_names)
  end
end
