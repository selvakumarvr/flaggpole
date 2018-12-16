class TwitterZip < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude
  has_many :rss_feeds
  has_many :twitter_followers
  has_many :twitter_mentions
  has_many :groupon_zips
  has_many :promotion_zips
  has_many :alert_zips, :dependent => :destroy
  has_many :alerts, :through => :alert_zips
  has_many :subscriptions, :as => :subscribable, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user

  scope :registered, :conditions => {:registered => true}
  scope :login_failure, :conditions => {:login_status => 0}
  scope :can_login, :conditions => {:login_status => 1}
  scope :suspended, :conditions => {:login_status => 2}
  # login_failure may include suspended accounts until determined that failure is due to suspension
  scope :rss_enabled, :include => :rss_feeds, :conditions => ['rss_feeds.enabled = ?', 1]
  scope :no_messages, lambda { |*args| {:conditions => ["NOT EXISTS (SELECT zip FROM zip_messages WHERE twitter_zips.zip = zip_messages.zip AND created_at_date > ?)", (args.first || 1.month.ago.to_date)]} }
  scope :no_outsidein, lambda { |*args| {:conditions => ["NOT EXISTS (SELECT zip FROM zip_messages WHERE twitter_zips.zip = zip_messages.zip AND created_at_date > ? AND source_id = #{Source.index('Outside.in')} )", (args.first || 1.week.ago.to_date)]} }
  scope :utc_offset, lambda { |*args| {:conditions => {:timezone => args.first}} }
  scope :msa, lambda { |*args| {:conditions => {:msa => args.first}} }
  attr_accessible :login_status, :followers_count

  LOGIN_TYPES = {
    # displayed stored in db
    :failure    => 0,
    :success    => 1,
    :suspended  => 2,
  }

  def self.valid_twitzip(zip)
    !!self.registered.can_login.find_by_zip(zip)
  end

  def self.update_followers_count(screen_names)
    zip = TwitterZip.can_login.all(:select => 'zip').sample.zip
    tz = TwitterZip.find_by_zip(zip)
    client = tz.login(false)
    users = client.users(*screen_names)
    users.each do |u|
      sql = "UPDATE twitter_zips SET followers_count=%d WHERE zip='%s'" % [u.followers_count, u.screen_name]
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  def login(verify = true)
    begin
      Twitter.configure do |config|
        config.consumer_key = AppConfig.twitter.consumer_key
        config.consumer_secret = AppConfig.twitter.consumer_secret
        config.oauth_token = self.oauth_token
        config.oauth_token_secret = self.oauth_secret
      end
      client = Twitter::Client.new
      client.verify_credentials if verify
    rescue Twitter::Error::Unauthorized, OAuth::Unauthorized
      client = nil
      failed!
      suspended! if suspended?
    else
      succeeded! if verify
    end

    return client
  end

  def tweet_messages
    zip_messages = ZipMessage.not_tweeted.all(:conditions => {:zip => zip})
    @client ||= self.login
    return unless @client

    zip_messages.each do |zm|
      zm.tweet(@client)
    end
  end

  def tweet(content)
    client ||= login(false)
    return unless client

    # have to catch any exceptions
    begin
      result = client.update(content)
      #result = client.update(content, {:lat => latitude.to_s, :long => longitude.to_s})
    rescue Twitter::Error::Unauthorized
      failed!
      suspended! if suspended?
    rescue Twitter::Error::BadGateway, Twitter::Error::ServiceUnavailable
      # ...
    else
      # runs if no exception
      succeeded!
    end
  end

  def direct_message_followers(message)
    message_length = message.length
    if message_length > 140
      puts "Message must be 140 characters or less. Message is #{message_length} characters"
      return
    end

    @client ||= self.login
    return unless @client

    follower_ids = @client.follower_ids.ids
    follower_ids.each do |f|
      puts "Direct Message to #{f}"
      begin
        @client.direct_message_create(f, message)
      rescue Exception => e
        puts "#{self.zip} #{f} #{e.message}"
        puts e.backtrace.inspect
      end
  	end
  end

  def fwix_items
    lat, lon = latitude.to_s, longitude.to_s
    return [] if (lat.empty? || lon.empty?)
    radius = 5
    # get only news items but if that is empty then get events
    items = Fwix.nearbyItems(lat, lon, radius, ['news'])
    items = Fwix.nearbyItems(lat, lon, radius, ['events']) if items.empty?
    items
  end

  def tweet_fwix
    self.fwix_items.each do |item|
      # check if item is new and if it is not too far in the past
      if item.new_item?(zip) && (item.datetime > 1.week.ago)
        zm_data = {:source_id => item.source_id, :zip => self.zip, :content => item.message, :uid => item.uid}
        #puts zm_data.inspect
        ZipMessage.create(zm_data) unless item.message.length > 140
        print "NEW "
      else
        print "OLD/EXPIRED "
      end

      puts "- #{item.message.length} - #{item.datetime.to_date} - #{item.message}"
      puts
    end
    nil
  end

  def weather
    Yahoo::Weather.message(zip)
  end

  def tweet_weather
    tweet(weather)
  end

  def update_followers
    @client ||= self.login
    return unless @client

    saved_followers = self.twitter_followers
    followers = @client.all_followers
    followers.each do |f|
      follower_attr = {
                  :name => f.name,
                  :screen_name => f.screen_name,
                  :location => f.location,
                  :description => f.description,
                  :url => f.url,
                  :followers_count => f.followers_count,
                  :friends_count => f.friends_count,
                  :following => f.following
                }
      follower = saved_followers.find_by_screen_name(f.screen_name) || self.twitter_followers.create
      follower.update_attributes(follower_attr)
    end

    # delete followers that are no longer following this twitter_zip
    screen_names = followers.map{|f| f.screen_name}
    saved_followers = self.twitter_followers
    saved_followers.each do |f|
      f.destroy unless screen_names.include? f.screen_name
    end
  end

  def follow_followers
    @client ||= self.login
    return unless @client

    follower_ids = @client.follower_ids.ids
    friend_ids = @client.friend_ids.ids
    to_follow_ids = follower_ids - friend_ids

    to_follow_ids.each do |f|
      begin
        @client.follow(f)
      rescue Twitter::Error::Forbidden => e
        raise unless e.message =~ /already requested to follow|account has been suspended/
      rescue Twitter::Error::NotFound
      end
  	end
  end

  def update_mentions
    @client ||= self.login
    return unless @client

    maximum_id = self.twitter_mentions.maximum(:mention_id) || 0
    page = 1

    # get first page of mentions (newest) and then get next pages (older)
    # until get page with mention were we left off (maximum_id)
    begin
      mentions = @client.mentions(:page => page)
      mentions.each do |m|
        if m.id > maximum_id
        #unless self.twitter_mentions.exists?(:mention_id => m.id)
          twitter_mention = self.twitter_mentions.create(
            :mention_id => m.id,
            :mention_created_at => m.created_at,
            :text => m.text,
            :source => m.source,
            :user_id => m.user.id,
            :user_screen_name => m.user.screen_name,
            :user_followers_count => m.user.followers_count,
            :user_friends_count => m.user.friends_count,
            :user_created_at => m.user.created_at,
            :user_statuses_count => m.user.statuses_count,
            :following => m.user.following
          )

          # Enqueue retweet of twitter_mention with high priority
          Delayed::Job.enqueue(RetweetMentionJob.new(twitter_mention.id), 5)
        end
      end
      page += 1
    end while(!mentions.empty? && !mentions.include?(maximum_id))
  end

  def keep_alive
    ZipMessage.create(:zip => zip, :content => 'TwitZip: Building a Twitter Zip Code Infrastructure for Consistent Public Use')
  end

  def get_oauth_tokens
    return unless self.oauth_token.nil?
    consumer_key = AppConfig.twitter.consumer_key
    consumer_secret = AppConfig.twitter.consumer_secret
    access_token = XAuth.retrieve_access_token(self.zip, self.password, consumer_key, consumer_secret)
    update_attributes(:oauth_token => access_token.token, :oauth_secret => access_token.secret)
  end

  # name, email, url, location, description
  def update_profile(profile)
    @client ||= self.login
    return unless @client
    @client.update_profile(profile)
  end

  def update_icon(filename)
    @client ||= self.login
    return unless @client
    icon = File.open(filename)
    @client.update_profile_image(icon)
  end

  def update_background(filename)
    @client ||= self.login
    return unless @client
    background = File.open(filename)
    @client.update_profile_background_image(background)
    @client.update_profile_colors(
      :profile_background_color     => '5e9cc0',
      :profile_text_color           => '000000',
      :profile_link_color           => '0084b4',
      :profile_sidebar_fill_color   => 'ddeef6',
      :profile_sidebar_border_color => 'c0deed'
    )
  end

  def delete_all_tweets
    @client ||= self.login
    return unless @client

    @client.user_timeline.each do |tweet|
      @client.status_destroy(tweet.id)
    end
  end

  def mechanize_login
    login_url = 'http://twitter.com/login'
    agent = WWW::Mechanize.new

    # login to Twitter
    page = agent.get(login_url)
    login_form = page.forms[1]
    login_form.field_with(:name => 'session[username_or_email]').value = self.zip
    login_form.field_with(:name => 'session[password]').value = self.password
    page = agent.submit(login_form)
    agent
  end

  def change_password(new_password)
    agent = self.mechanize_login
    password_url = 'http://twitter.com/account/password'

    # change password
    page = agent.get(password_url)
    form = page.form_with(:name => 'f')
    form.field_with(:name => 'current_password').value = self.password
    form.field_with(:name => 'user_password').value = new_password
    form.field_with(:name => 'user_password_confirmation').value = new_password
    page = agent.submit(form)

    #  check for success
    success = (page.body =~ /Your password has been changed/)

    # update database with new password
    self.update_attributes(:password => new_password) if success

    return success
  end

  def enable_geolocation
    agent = self.mechanize_login
    geo_url = 'http://twitter.com/account/settings/geo'

    # enable geolocation
    page = agent.get(geo_url)
    form = page.forms.first
    page = agent.submit(form) if page.body =~ /Turn location on/

    #  check for success
    success = (page.body =~ /Location is \<span.*ON\<\/span\> for your account/)

    return success
  end

  def account_exists?
    url = 'http://twitter.com/' + self.zip.to_s
    res = Net::HTTP.get_response(URI.parse(url))
    res.code == "200"
  end

  def suspended?
    zip = TwitterZip.can_login.all(:select => 'zip').sample.zip
    tz = TwitterZip.find_by_zip(zip)
    client = tz.login(false)
    begin
      client.user(self.zip)
    rescue Twitter::Error::Forbidden => exception
      return true if exception.to_s =~ /suspended/
    end
    false
  end

  def suspended2?
    url = "http://twitter.com/users/show_for_profile.json?screen_name=" + self.zip
    res = Net::HTTP.get_response(URI.parse(url))
    obj = JSON.parse(res.body)
    obj.has_key?('error') && (obj['error'] == 'User has been suspended')
  end

  def check_suspended
    if self.suspended2?
      self.suspended!
      puts self.zip + " suspended"
    else
      self.succeeded!
      puts self.zip + " succeeded"
    end
  end

  def failed!
    update_attributes(:login_status => LOGIN_TYPES[:failure])
  end

  def succeeded!
    update_attributes(:login_status => LOGIN_TYPES[:success])
  end

  def suspended!
    update_attributes(:login_status => LOGIN_TYPES[:suspended])
  end

  def self.export_json
    path = File.join([Rails.root, "public", "zipcodes.json"])
    File.open(path, "w") do |f|
      f.write TwitterZip.select([:id, :zip, :city, :state]).all.to_json
      #f.write ActiveModel::ArraySerializer.new(
      #  Organization.select([:id, :name, :district_nces_id, :nces_id]).all,
      #  each_serializer: SimpleOrganizationSerializer
      #).to_json
    end

    # write gziped file
    gz_path = File.join([Rails.root, "public", "zipcodes.json.gz"])
    gz = Zlib::GzipWriter.new(File.open(gz_path, "wb"))
    gz.write File.read(path)
    gz.close
  end

end
