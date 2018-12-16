class CrawlRssFeedJob < Struct.new(:rss_feed_id, :rss_url)
  def perform
    rss_feed = RssFeed.find(rss_feed_id)
    rss_feed.perform_crawl
    rss_feed.update_attributes(:enqueued => false)
  end
end
