class UpdateMentionsJob < Struct.new(:twitter_zip_id)
  def perform
    twitter_zip = TwitterZip.find(twitter_zip_id)
    twitter_zip.update_mentions
  end
end
