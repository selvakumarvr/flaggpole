namespace :twitzip do

  desc "Check for new FEMA IPAWS alerts, insert into database and tweet them"
  task :fema_ipaws => :environment do
    FemaIpaws.process
  end

  desc "Check for new NOAA alerts, insert into database and tweet them"
  task :noaa_alerts => :environment do
    NoaaAlerts.process
  end

  desc "Crawl the enabled RSS feeds that have Twitter accounts that are registered and we can login"
  task :crawl => :environment do
    # find enabled RSS feeds for Twitter accounts that are registered and we can login
    RssFeed.crawlable.not_enqueued.all(:include => :crawl).each do |feed|
      # skip crawling feed if last crawl had 0 messages and it was crawled within past 1 day
      next if (feed.crawl.message_count == 0 && feed.crawl.updated_at > 4.hours.ago)
      puts "Enqueueing #{feed.id} #{feed.rss_url}"
      Delayed::Job.enqueue(CrawlRssFeedJob.new(feed.id, feed.rss_url), 10)
      feed.update_attributes(:enqueued => true)
    end
  end

  desc "Crawl the enabled RSS feeds using the Outside.in API instead of RSS"
  task :crawl_outsidein => :environment do
    # find enabled RSS feeds for Twitter accounts that are registered and we can login
    RssFeed.crawlable.not_enqueued.all(:include => :crawl).each do |feed|
      # skip crawling feed if last crawl had 0 messages and it was crawled within past 1 day
      next if (feed.crawl.message_count == 0 && feed.crawl.updated_at > 4.hours.ago)
      puts "Enqueueing #{feed.id} #{feed.rss_url}"
      Delayed::Job.enqueue(CrawlOutsideInJob.new(feed.id), 10)
      feed.update_attributes(:enqueued => true)
    end
  end

  desc "Crawl all RSS feeds that have Twitter accounts that are registered and we can login"
  task :crawl_all => :environment do
    # find all RSS feeds for Twitter accounts that are registered and we can login
    RssFeed.all_crawlable.not_enqueued.each do |feed|
      puts "Enqueueing #{feed.id} #{feed.rss_url}"
      Delayed::Job.enqueue(CrawlRssFeedJob.new(feed.id, feed.rss_url), 10)
      feed.update_attributes(:enqueued => true)
    end
  end

  desc "Crawl the RSS feeds for each TwitZip and follow the followers"
  task :crawl_and_follow => :environment do
    twitter_zips = TwitterZip.can_login
    twitter_zips.each do |tz|
      rss_feeds = tz.rss_feeds.not_enqueued
      rss_feed_ids = rss_feeds.map(&:id)
      Delayed::Job.enqueue(CrawlAndFollowJob.new(tz.id, rss_feed_ids), 10)
      rss_feeds.each {|feed| feed.update_attributes(:enqueued => true) }
    end
  end

  desc "Crawl the Outside.in API for each TwitZip and follow the followers"
  task :crawl_outsidein_and_follow => :environment do
    twitter_zips = TwitterZip.can_login
    twitter_zips.each do |tz|
      rss_feeds = tz.rss_feeds.not_enqueued
      rss_feed_ids = rss_feeds.map(&:id)
      Delayed::Job.enqueue(CrawlOutsideInAndFollowJob.new(tz.id, rss_feed_ids), 10)
      rss_feeds.each {|feed| feed.update_attributes(:enqueued => true) }
    end
  end

  desc "Create messages with Fwix data for TwitZips that haven't had Outside.in data in past week"
  task :crawl_fwix => :environment do
    twitter_zips = TwitterZip.can_login.no_outsidein(1.week.ago)
    twitter_zips.each do |tz|
      puts "Enqueueing #{tz.zip}"
      Delayed::Job.enqueue(CrawlFwixJob.new(tz.zip), 10)
    end
  end

  desc "Tweet the weather to the enabled TwitterZips"
  task :tweet_weather => :environment do
    offset = 20 - Time.now.getutc.hour
    offset = offset - 24 if offset > 12
    puts "Finding twitter_zips with UTC offset of: #{offset}"
    TwitterZip.registered.can_login.rss_enabled.utc_offset(offset).each do |tz|
      puts "Enqueueing #{tz.zip} #{tz.city}"
      Delayed::Job.enqueue(TweetWeatherJob.new(tz.zip), 9)
      # TODO priority queue, run_at time?
    end
  end

  desc "Enqueue the zip_messages to be tweeted"
  task :tweet => :environment do
    zip_messages = ZipMessage.not_tweeted.not_enqueued

    #zip_messages.each do |zm|
    #  Delayed::Job.enqueue(TweetZipMessageJob.new(zm.id, zm.zip), 9)
    #  zm.update_attributes(:enqueued => true)
    #end

    untweeted_zips = zip_messages.all(:select => :zip, :group => :zip).map(&:zip)
    untweeted_zips.each do |zip|
      Delayed::Job.enqueue(TweetZipMessagesForZipJob.new(zip), 9)
      zip_messages_for_zip = ZipMessage.not_tweeted.not_enqueued.all(:conditions => {:zip => zip})
      ZipMessage.update_all({:enqueued => true}, {:id => zip_messages_for_zip})
    end
  end

  desc "Update the Commission Junction links for each GrouponDivision"
  task :update_cj_links => :environment do
    GrouponDivision.populate_cj_links
  end

  desc "Get the Groupon deals and create the zip_messages"
  task :tweet_groupon => :environment do
    GrouponDivision.all.each do |gd|
      if GrouponDivision::TWEET_TIMES.include?(gd.local_time.hour)
        puts "Tweeting deals for #{gd.name}"
        gd.tweet
      end
    end
  end

  desc "Update the list of GrouponDivisions and GrouponZips"
  task :update_groupon => :environment do
    GrouponDivision.populate
    GrouponDivision.set_msa_names
    GrouponZip.populate
  end

  desc "Enqueue a list of zips to get their latest mentions and retweet the mentions"
  task :update_mentions => :environment do
    zips = ['ejunkertest','twitzipbot']
    msas = [2120, 7602] # Des Moines, Seattle
    twitter_zips = TwitterZip.registered.can_login.all(:conditions => ["zip IN (?) OR msa IN (?)", zips, msas])
    twitter_zips.each do |tz|
      Delayed::Job.enqueue(UpdateMentionsJob.new(tz.id), 6)
    end
  end

  desc "Enqueue a list of zips to have their list of followers updated"
  task :update_followers => :environment do
    twitter_zips = TwitterZip.registered.can_login
    twitter_zips.each do |tz|
      Delayed::Job.enqueue(UpdateFollowersJob.new(tz.id), 10)
    end
  end

  desc "Enqueue commands to update the followers_count for each TwitZip"
  task :update_followers_count => :environment do
  	TwitterZip.all(:select => 'zip').map(&:zip).in_groups_of(100, false).each do |screen_names|
		  Delayed::Job.enqueue(UpdateFollowersCountJob.new(screen_names), 10)
	  end
  end

  desc "For each TwitZip have it follow the people that are following it"
  task :follow_followers => :environment do
    twitter_zips = TwitterZip.can_login
    twitter_zips.each do |tz|
      Delayed::Job.enqueue(FollowFollowersJob.new(tz.id), 10)
    end
  end

  desc "Check all TwitZips to see if we can login and/or if the account is suspended"
  task :check_login_status => :environment do
    TwitterZip.all.each do |tz|
      tz.delay.login(true)
    end
  end

  desc "Tweet the keep alive message to zips that do not have any messages in the past month"
  task :tweet_keep_alive => :environment do
    twitter_zips = TwitterZip.can_login.no_messages(6.months.ago)
    twitter_zips.each do |tz|
      tz.delay.keep_alive
    end
  end

  desc "Reset DelayedJob jobs that have more than 1 attempt to like new state"
  task :reset_jobs => :environment do
    Delayed::Job.update_all("attempts=0,last_error=null,run_at=NOW(),locked_at=null,failed_at=null,locked_by=null", "attempts > 0")
  end

  desc "Delete jobs from the delayed_job queue based on their handler"
  task :delete_jobs, [:handler] => [:environment] do |t, args|
    if args.handler.nil?
      puts "Usage: rake twitzip:delete_jobs['my_handler']"
      puts "Handlers: CrawlRssFeedJob, UpdateMentionsJob, TweetZipMessageJob, etc."
    else
      handler = args.handler.strip
      Delayed::Job.delete_all(["handler LIKE ?", "%#{handler}%"])
    end
  end

  desc "Delete jobs from the delayed_job queue based on their last_error"
  task :delete_jobs_by_error, [:last_error] => [:environment] do |t, args|
    if args.last_error.nil?
      puts "Usage: rake twitzip:delete_jobs_by_error['last_error']"
    else
      last_error = args.last_error.strip
      Delayed::Job.delete_all(["last_error LIKE ?", "%#{last_error}%"])
    end
  end

  desc "Delete jobs that failed due to Bitly hourly rate limit"
  task :delete_bitly_rate_limit => :environment do
    Delayed::Job.delete_all(["last_error LIKE ?", "%You have exceeded your hourly rate limit%"])
  end

  desc "Delete all ShortUrls that haven't been used in the past month"
  task :delete_old_short_urls => :environment do
    ShortUrl.delete_all(["updated_at < ?", 1.month.ago])
  end

  desc "Delete ZipMessages older than 3 months"
  task :delete_old_zip_messages => :environment do
    ZipMessage.delete_all(["created_at_date < ?", 3.months.ago])
  end

  desc "Print the current number of Delayed Jobs"
  task :jobs => :environment do
    num_jobs = Delayed::Job.all.count
    puts "Delayed Jobs: #{num_jobs}"
  end

  desc "Import a list of zips from a CSV file into twitter_zips"
  task :import_csv => :environment do
    #csv_file = File.join(File.dirname(__FILE__),'zips_small.csv')
    csv_file = File.join(Rails.root,'lib','twitzips','zips.csv')
    puts "Importing zip data from " + csv_file

    Excelsior::Reader.rows(File.open(csv_file, 'rb')) do |row|
      twitter_zip = {
          :zip => row[0],
          :population => row[1],
          :password => row[2],
          :email => row[3],
          :registered => (row[4] == 'success')
      }
      TwitterZip.create!(twitter_zip)
    end
  end

end
