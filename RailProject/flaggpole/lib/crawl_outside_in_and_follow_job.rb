class CrawlOutsideInAndFollowJob < Struct.new(:twitter_zip_id, :rss_feed_ids)
  def perform
    # crawl RSS feed
    #rss_feed_ids = [rss_feed_ids.first]
    rss_feed_ids.each do |rss_feed_id|
      rss_feed = RssFeed.find(rss_feed_id)
      rss_feed.crawl_outsidein(delay = 1)
      rss_feed.update_attributes(:enqueued => false)
    end
    
    # follow followers
    twitter_zip = TwitterZip.find(twitter_zip_id)
    twitter_zip.follow_followers
  end
end
