module FeedNormalizer
  class Entry
    attr_accessor :short_url, :via
    DAYS_THRESHOLD = 30.days
    
    def new_item?(zip)
      !(item_exists?(zip) || older_than_threshold?)
      #!title_exists?(zip)
    end
    
    def message(feed_url, shorten_url = true)
      self.short_url = 'http://bit.ly/??????'
      self.short_url = ShortUrl.shorten(self.url).short_url if shorten_url
      feed_url.gsub!('.html','')
      self.via = 'http://outside.in' + feed_url
      
      # shorten some fields if necessary
      shorten!
      message_string
    end
    
    def uid
      # cache uid since it may change if title is shortened
      @uid ||= Digest::MD5.hexdigest("#{url}#{title}")
      #@uid ||= Digest::MD5.hexdigest("#{title}")
      @uid
    end
    
    def log_string(message)
      msg_len = message.length
      "#{uid} #{date_published}\n#{msg_len} #{message}"
    end
    
    protected
    
    def message_string
      "#{title} #{short_url} via #{via}".strip
    end
    
    def shorten!
      shorten_field!(:title)
      shorten_field!(:author)
    end
    
    def shorten_field!(field)
      excess = message_string.length - 140
      self.send(field).slice!(-excess,excess) if excess > 0
    end
    
    def title_exists?(zip)
      ZipMessage.exists?(['zip = ? AND content LIKE ?', zip, "%#{self.title}%"])
    end
    
    def older_than_threshold?
      (Time.now - date_published) > DAYS_THRESHOLD
    end
    
    def item_exists?(zip)
      ZipMessage.exists?(:uid => uid, :zip => zip)
    end

  end
end