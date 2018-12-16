class TweetZipMessagesForZipJob < Struct.new(:zip)
  def perform
    zip_messages = ZipMessage.not_tweeted.all(:conditions => {:zip => zip, :created_at_date => (Time.now - 1.day)..Time.now})
    twitter_zip = TwitterZip.find_by_zip(zip)
    puts "Tweeting #{zip_messages.count} tweets for #{twitter_zip.zip}"
    client = twitter_zip.login(false)
    zip_messages.each do |zm|
      zm.tweet(client, twitter_zip)
      zm.update_attributes(:enqueued => false)
    end
  end
end
