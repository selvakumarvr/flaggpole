class Alert < ActiveRecord::Base
  attr_accessible :short_url
  has_many :infos, :dependent => :destroy
  has_many :alert_zips, :dependent => :destroy
  has_many :twitter_zips, :through => :alert_zips

  validates_presence_of :identifier, :sender, :sent, :status, :msg_type, :scope
  validates_inclusion_of :status, :in => %w(Actual Exercise System Test Draft)
  validates_inclusion_of :msg_type, :in => %w(Alert Update Cancel Ack Error)
  validates_inclusion_of :scope, :in => %w(Public Restricted Private)

  def zips
    self.infos.map(&:zips).flatten.uniq
  end

  def same_codes
    self.infos.map(&:same_codes).flatten.uniq
  end

  # GEO_ID for use with: https://www.google.com/fusiontables/DataSource?docid=0IMZAFCwR-t7jZnVzaW9udGFibGVzOjIxMDIxNw
  def geo_ids
    self.same_codes.map{|s| '05000US' + s[1..-1] }
  end

  def utc_offset
    self.twitter_zips.first.timezone
  end

  def headline
    self.infos.first.headline
  end

  def tweet_content(zip)
    # https://dev.twitter.com/docs/api/1/get/help/configuration
    short_url_length = 22
    zip_colon_length = 7
    max_tweet_length = 140
    headline = self.headline
    url = self.twitzip_url

    # trim headline if too long (7 for zip, colon, and space, 20 chars for URL, 113 for headline and space)
    excess = (headline.length + 1) - (max_tweet_length - short_url_length - zip_colon_length)
    headline.slice!(-excess, excess) if excess > 0
    "#{zip}: #{headline} #{url}"
  end

  def twitzip_url
    "http://twitzip.com/alerts/" + self.id.to_s
  end

  def set_short_url
    short_url = ShortUrl.yourls(twitzip_url)
    update_attributes(:short_url => short_url.yourls_url)
  end

  def create_zip_messages(source)
    uid = self.identifier
    self.twitter_zips.registered.can_login.each do |tz|
      unless ZipMessage.exists?(:uid => uid, :zip => tz.zip)
        msg = self.tweet_content(tz.zip)
        zm = {:source_id => source, :zip => tz.zip, :content => msg, :uid => uid}
        ZipMessage.create(zm)
      end
    end
  end

  def enqueue_zip_messages(source)
    Delayed::Job.enqueue(TweetZipMessagesForAlertJob.new(self.id), :priority => 5)
    zips = self.twitter_zips.map(&:zip)
    zms = ZipMessage.not_tweeted.not_enqueued.where(:zip => zips).where(:source_id => source).all
    ZipMessage.update_all({:enqueued => true}, {:id => zms})
    zms.length
  end

  def subscribers
    users = []
    self.twitter_zips.includes(:subscribers).each do |tz|
      users += tz.subscribers.inject([]) { |tz_users, user| tz_users << user }
    end
    users
  end

  def subscribed_devices
    Device.where(:user_id => subscribers).uniq
  end

  def rapns_app
    Rapns::Apns::App.find_by_name("meerkat_ios_production")
  end

  def enqueue_apns
    @app ||= rapns_app
    subscribed_devices.each do |d|
      attributes = {id: id, type: 'Alert'}
      APN::push(app: @app, token: d.token, message: headline, attributes: attributes)
    end
  end

end
