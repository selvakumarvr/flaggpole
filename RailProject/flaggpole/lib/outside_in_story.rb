class OutsideInStory
  NAMES = %w(title feed_title story_url)
  attr_accessor *NAMES
  attr_reader :uid
  
  def initialize(story, zip)
    NAMES.each do |var_name|
      self.instance_variable_set("@#{var_name}", story[var_name])
    end
    @source_id = Source.index('Outside.in')
    @title ||= ''
    @url = @story_url.blank? ? '' : @story_url
    @uid = Digest::MD5.hexdigest(@title)
    @zip = zip
  end

  def message
    # https://dev.twitter.com/docs/api/1/get/help/configuration
    short_url_length = 22
    max_tweet_length = 140

    # trim headline if too long (20 chars for URL, 120 for title and space)
    excess = (@title.length + 1) - (max_tweet_length - short_url_length)
    @title.slice!(-excess, excess) if excess > 0
    "#{@title} #{@url}"
  end

  def log_string(message)
    msg_len = message.length
    "#{uid} #{msg_len}\n#{message}"
  end
  
  def new?
    !ZipMessage.exists?(:uid => @uid, :zip => @zip)
  end

end
