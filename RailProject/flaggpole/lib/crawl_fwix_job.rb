class CrawlFwixJob < Struct.new(:zip)
  def perform
    twitter_zip = TwitterZip.find_by_zip(zip)
    twitter_zip.tweet_fwix
  end
end
