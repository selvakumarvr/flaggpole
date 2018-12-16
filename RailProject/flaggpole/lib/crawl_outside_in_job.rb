class CrawlOutsideInJob < Struct.new(:rss_feed_id)
  def perform
    rss_feed = RssFeed.find(rss_feed_id)
    rss_feed.crawl_outsidein(delay = 1)
    rss_feed.update_attributes(:enqueued => false)
  end
end
