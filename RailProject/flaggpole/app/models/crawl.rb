class Crawl < ActiveRecord::Base
  belongs_to :rss_feed
  attr_accessible :message_count, :etag, :updated_at
end
