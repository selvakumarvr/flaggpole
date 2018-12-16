class GrouponDivision < ActiveRecord::Base
  has_many :groupon_zips
  has_many :twitter_zips, :through => :groupon_zips
  BASE_URI = 'http://api.groupon.com/v2/'
  TWEET_TIMES = [8]
  @@log = Logger.new(Rails.root.join("log","groupon.log"),'daily')
  @@log.level = Logger::DEBUG
  
  def home_url
    "http://www.groupon.com/#{self.division_id}"
  end
  
  def local_time
    Time.now.in_time_zone(self.timezone)
  end
  
  def self.add_api_key(url)
    url + (URI.parse(url).query ? '&'  : '?') + 'client_id=' + AppConfig.groupon_token
  end
  
  def self.api_get(path)
    url = BASE_URI + path
    url = add_api_key(url)
    data = open(url).read
    JSON.parse(data)
  end
  
  # returns the deals for the division
  def deals
    response = self.class.api_get("deals.json?division_id=#{division_id}")
    @deals = response['deals']
  end
  
  # returns the message content for a deal
  def content(deal)
    shorten_url = true
    title = deal['title'] 
    #deal_url = deal['deal_url'] + '?utm_source=aatwitzip'
    cj_link = self.cj_link || CommissionJunction::DEFAULT_LINK
    deal_url = cj_link + '?url=' + CGI::escape(deal['dealUrl'])
    short_url = 'http://bit.ly/?????'
    short_url = ShortUrl.shorten(deal_url).short_url if shorten_url
    content = "#{title} #{short_url} via Groupon" # " for 12345" is appended in #tweet

    # shorten title if > 140 characters
    extra_length = " for 12345".length
    excess = content.length + extra_length - 140
    if excess > 0
      title.slice!(-excess,excess)
      content = "#{title} #{short_url}"
    end
    
    content
  end
  
  def message(deal)
    content = self.content(deal)
    uid = Digest::MD5.hexdigest("#{deal['id']}#{deal['start_date']}")
    {:content => content, :uid => uid}
  end
  
  # returns array of formatted tweet messages
  def messages
    @deals ||= self.deals
    if @deals.empty?
      puts "Empty deals"
      return
    end
    
    @deals = [@deals.first] # only include first deal for now
    messages = @deals.map{|deal| self.message(deal)}
  end
  
  def new_message?(message)
    !ZipMessage.exists?(:uid => message[:uid])
  end
  
  def tweet
    return if msa.nil?
    @@log.debug "Tweeting deals for #{name}"
    @source_id ||= Source.index('Groupon')
    @messages ||= self.messages
    #twitter_zips = TwitterZip.registered.can_login.find_all_by_msa(msa)
    twitter_zips = self.twitter_zips
    
    @messages.each do |m|
      next unless self.new_message?(m)
      twitter_zips.each do |tz|
        content = m[:content] + " for #{tz.zip}"
        zm_data = {:source_id => @source_id, :zip => tz.zip, :content => content, :uid => m[:uid]}
        #puts zm_data.inspect
        zm = ZipMessage.create(zm_data)
        @@log.debug Time.now.to_s + ' '+ zm.inspect
        
        # immediately enqueue the ZipMessage to be tweeted
        Delayed::Job.enqueue(TweetZipMessageJob.new(zm.id, zm.zip), 9)
        zm.update_attributes(:enqueued => true)
      end
    end
    nil
  end
  
  # find zip with most Outside.in tweets in past 30 days
  def featured_zip
    zips = self.twitter_zips.map(&:zip)
    return if zips.empty?
    zms = ZipMessage.find_by_sql(['SELECT zip, count(*) as tweet_count FROM zip_messages WHERE source_id = ? AND zip IN (?) AND created_at > ? GROUP BY zip ORDER BY tweet_count DESC', 1, zips, 30.days.ago])
    zms.first.zip
  end
  
  def self.featured_zips
    self.all.map{|gd| {gd.name => gd.featured_zip}}
  end
  
  def self.divisions
    response = self.api_get('divisions.json')
    response['divisions']
  end
  
  def self.division_ids
    divisions = self.divisions
    divisions.map{|d| d['id']}
  end
  
  # divisions from API that do not exist in database
  def self.missing_divisions
    db_divisions = self.all.map{|x| x.division_id}.to_set
    api_divisions = self.division_ids.to_set
    missing = api_divisions - db_divisions
    missing.to_a
  end
  
  # divisions that exist in the database but not in the API
  def self.stale_divisions
    db_divisions = self.all.map{|x| x.division_id}.to_set
    api_divisions = self.division_ids.to_set
    missing = db_divisions - api_divisions
    missing.to_a
  end
  
  def self.populate_cj_links
    cj_links = CommissionJunction.link_uris
    all.each do |gd|
      link = cj_links[gd.division_id]
      gd.update_attributes(:cj_link => link)
    end
    nil
  end
  
  # add any missing divisions
  # use set_msa_names to populate msa and msa_name
  def self.populate
    divisions = self.divisions
    divisions.each do |d|
      unless exists?(:division_id => d['id'])
        puts "Creating #{d['id']}"
        create!(
          :division_id => d['id'],
          :name => d['name'],
          :timezone => d['timezone'],
          :timezone_offset_gmt => d['timezoneOffsetInSeconds'],
          :latitude => d['lat'],
          :longitude => d['lng']
        )
      end
    end
    nil
  end

  # not found stlouis MO, washington-dc
  # wrong match charlotte NC, columbus OH, jacksonville FL, portland OR
  def self.set_msa_names
    all.each do |d|
      name = d.name.split('/').first.strip
      tz = TwitterZip.all(:conditions => ['msa_name LIKE ?', "%#{name}%"]).first
      if tz.nil?
        puts "===== FAIL for #{name}"
      else
        puts "#{d.division_id},#{tz.msa_name},#{tz.msa}"
        
        #msa_point = Geokit::LatLng.new()
        #division_point = Geokit::LatLng.new()
        #distance = msa_point.distance_to(division_point)
        #puts "distance: #{distance}"
        
        if d.msa.nil?
          puts "Setting #{d.division_id} as #{tz.msa_name},#{tz.msa}"
          d.update_attributes(:msa => tz.msa, :msa_name =>tz.msa_name)
        end
      end
    end
    nil
  end

end
