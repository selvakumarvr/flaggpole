require File.join(Rails.root,'lib','twitzips','twit_zip_bot.rb')

class TwitterMention < ActiveRecord::Base
  belongs_to :twitter_zip
  
  def retweet
    tz = self.twitter_zip
    @client ||= tz.login
    
    # retweet message
    begin
      result = @client.retweet(self.mention_id)
    rescue Twitter::Error::Unauthorized
      tz.failed!
      tz.suspended! if tz.suspended?
    rescue Twitter::Error::BadGateway, Twitter::Error::ServiceUnavailable
      # ...
    else
      retweeted!
      tz.succeeded!
      puts "Retweeted mention #{self.id} from #{user_screen_name} to #{tz.zip}"
    end
  end
  
  def reply?
    tz = self.twitter_zip
    self.text.starts_with?('@' + tz.zip)
  end
  
  def spam?
    @grade ||= self.grade
    @grade < 70
  end
  
  def grade
    url = "http://tweetblocker.com/api/username/#{self.user_screen_name}.json"
    res = Net::HTTP.get_response(URI.parse(url))
    begin
      @spam_score = JSON.parse(res.body)['candidate']['score']
    rescue
      # default to 100 if parsing fails
      100
    end  
  end
  
  def retweeted!
    update_attributes(:retweeted => true)
  end

  # search for #twitzip mentions that tweetstream may miss
  def self.search
    log = Logger.new(Rails.root + 'log/twitter_search.log')
    
    since_date = Date.today.to_s
    search = Twitter::Search.new(:user_agent => 'twitzip.com')
    search = search.result_type('recent').per_page(100).hashtag('twitzip')
    search = search.since_date(since_date)
    
    search.each do |m|
      # check if tweet mentions a zip
      unless m.text =~ /(^|\s+)@(\d{5})(\s+|$)/
        log.info "#{Time.now} ERROR: Does not mention a TwitZip\n#{m.from_user}: #{m.text}\n"
        next
      end
      zip = $2
    
      # find the TwitterZip
      tz = TwitterZip.find_by_zip(zip)
      if tz.nil?
        log.info "#{Time.now} ERROR: Could not find TwitterZip with zip #{zip}\n"
        next
      end
      
      unless TwitterMention.exists?(:twitter_zip_id => tz.id, :text => m.text)
        tm = {
          :mention_id => m.id,
          :mention_created_at => m.created_at,
          :text => m.text,
          :source => m.source,
          :user_id => m.from_user_id,
          :user_screen_name => m.from_user
        }
        twitter_mention = tz.twitter_mentions.create(tm)
        log.info "#{Time.now} Created TwitterMention #{twitter_mention.id} for zip #{zip}\n#{twitter_mention.text}"
      
        # Enqueue retweet of twitter_mention with high priority
        Delayed::Job.enqueue(RetweetMentionJob.new(twitter_mention.id), 5)
      end
      
      log.info ''
    end
  end

end
