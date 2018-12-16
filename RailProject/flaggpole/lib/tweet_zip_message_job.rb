class TweetZipMessageJob < Struct.new(:zip_message_id, :zip)
  def perform
    zip_message = ZipMessage.find(zip_message_id)
    zip_message.tweet
    zip_message.update_attributes(:enqueued => false)
  end
end
