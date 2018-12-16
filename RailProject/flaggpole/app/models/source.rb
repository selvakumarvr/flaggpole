class Source < ActiveRecord::Base
  has_many :zip_messages
  has_many :rss_feeds
  has_many :twitter_zips, :through => :rss_feeds
  
  SOURCES = ['dummy','Outside.in','EveryBlock','Groupon','Fwix', 'FEMA', 'NOAA']
  
  def self.index(name)
    SOURCES.index(name)
  end

  def self.source(index)
    SOURCES.fetch(index)
  end

end
