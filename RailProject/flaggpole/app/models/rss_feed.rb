require File.join(Rails.root,'lib','twitzips','rss_item.rb')

class RssFeed < ActiveRecord::Base
  belongs_to :source
  belongs_to :twitter_zip
  has_one :crawl
  scope :enabled, :conditions => {:enabled => true}
  scope :crawlable, :include => :twitter_zip, :conditions => ['rss_feeds.enabled = ? AND twitter_zips.registered = ? AND twitter_zips.login_status = ?', 1, 1, 1]
  scope :all_crawlable, :include => :twitter_zip, :conditions => ['twitter_zips.registered = ? AND twitter_zips.login_status = ?', 1, 1]
  scope :not_enqueued, :conditions => {:enqueued => false}
  attr_accessible :enqueued
  MAX_NEW_STORIES_PER_CRAWL = 5
  
  def perform_crawl(delay = 0)
    @zip ||= self.twitter_zip.zip
    puts 'Crawling ' + @zip
    curl, feed = fetch
    puts "response code: #{curl.response_code} "
    message_count = process_feed(feed)
    etag = etag_from_header(curl.header_str)
    record_crawl(message_count, etag)
    
    # try to make sure connection is not held open
    curl.reset
    curl.close
    curl = nil
    
    # tweet all zip_messages for this zip
    #self.twitter_zip.tweet
    #self.twitter_zip.delay.tweet
    
    # Add delay at request of Outside.in to lower our requests per second
    sleep delay
  end
  
  def crawl_outsidein(delay = 0)
    @zip ||= self.twitter_zip.zip
    message_count = 0
    puts 'Crawling ' + @zip

    begin
      response = OutsideInApi.stories(@zip)
      message_count = process_outsidein(response)
    rescue Exception => e
      raise unless e.message =~ /resource not found/
    ensure
      record_crawl(message_count, etag = '')
      # Add delay at request of Outside.in to lower our requests per second
      sleep delay
    end

  end
  
  private
  
  def fetch
    crawl = get_crawl
    options = {}
    options.merge!(:etag => crawl.etag) unless crawl.etag.nil?
    puts "Fetching #{self.rss_url} etag #{crawl.etag}"
    curl = build_curl_easy(options)
    curl.perform
    feed = process_curl_response(curl)
    #Feedtosis::Result.new(curl, feed)
    # Close the connection. Prevent high number of connections to Outside.in
    curl.close
    [curl, feed]
  end
  
  def process_feed(feed)
    message_count = 0
    return message_count if feed.nil?
    @zip ||= self.twitter_zip.zip
    
    feed.items.each do |item|
      if item.new_item?(@zip)
        message = item.message(feed.url, true)
        enqueue_message(message, item.uid) unless message.length > 140
        message_count += 1
        print "NEW "
      else
        message = item.message(feed.url, false)
        print "OLD "
      end
      
      puts item.log_string(message)
      puts
    end
    
    message_count
  end
  
  def process_outsidein(response)
    message_count = 0
    return message_count if response.nil?
    @zip ||= self.twitter_zip.zip
    
    stories = response['stories']
    stories.collect! {|s| OutsideInStory.new(s, @zip)}
    
    stories.each do |story|
      break unless message_count < MAX_NEW_STORIES_PER_CRAWL
      if story.new?
        message = story.message
        enqueue_message(message, story.uid) unless message.length > 140
        message_count += 1
        print "NEW "
      else
        message = story.message
        print "OLD "
      end
      
      puts story.log_string(message)
      puts
    end
    
    message_count    
  end
  
  def enqueue_message(msg, uid)
    # TODO change zip_messages to use rss_feed_id instead of source_id and zip
    zm = {:source_id => self.source.id, :zip => self.twitter_zip.zip, :content => msg, :uid => uid}
    zm.each_pair{|key,val| puts "#{key}: #{val}"}
    ZipMessage.create(zm)
  end
  
  def record_crawl(message_count, etag)
    crawl = get_crawl
    # Update the crawl and force updated_at to update even if other attributes are the same
    crawl.update_attributes(:message_count => message_count, :etag => etag, :updated_at => Time.now)
  end
  
  def get_crawl
    self.crawl || self.create_crawl
  end
  
  def etag_from_header(header)
    header =~ /.*ETag:\s(.*)\r/
    $1
  end
  
  # Based on Feedtosis http://github.com/jsl/feedtosis
  
  # Processes the results if the response is a 200. Otherwise, returns the
  # Curl::Easy object for the user to inspect.
  def process_curl_response(curl)
    if curl.response_code == 200
      response = parser_for_xml(curl.body_str)
      #response = mark_new_entries(response)
      #store_summary_to_backend(response, curl)
      response
    end
  end
  
  # Sets options for the Curl::Easy object, including parameters for HTTP
  # conditional GET.
  def build_curl_easy(options = {})
    curl = new_curl_easy(self.rss_url)
 
    # Many feeds have a 302 redirect to another URL. For more recent versions
    # of Curl, we need to specify this.
    curl.follow_location = true
      
    set_header_options(curl, options)
  end
  
  def new_curl_easy(url)
    Curl::Easy.new(url)
  end
  
  # Sets the headers
  def set_header_options(curl, options = {})
    curl.headers['User-Agent'] = 'twitzip.com'
    curl.headers['If-None-Match'] = options[:etag] unless options[:etag].nil?
    curl.headers['If-Modified-Since'] = options[:last_modified] unless options[:last_modified].nil?
    # try to force not to keep connection open to Outside.in
    curl.headers['Connection'] = 'close'
    curl.headers['Keep-Alive'] = ''
    curl
  end
  
  def parser_for_xml(xml)
    FeedNormalizer::FeedNormalizer.parse(xml)
  end
  
end
