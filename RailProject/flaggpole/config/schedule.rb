# Command to update cron: whenever --update-crontab flaggpole
set :environment, :production
set :output, {:error => nil, :standard => nil}

# If your ruby binary isn't in a standard place (for example if it's in /usr/local/bin,
# because you installed it yourself from source, or from a thid-party package like REE),
# this tells whenever (or really, the rails runner) where to find it.
env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'

# Set timezone
env :TZ, 'America/Chicago'

# crawl every 2 hours from 6am to midnight
every 1.day, :at => ['06:10','08:10','10:10','12:10','14:10','16:10','18:10','20:10','22:10','00:10'] do
  rake "twitzip:crawl_outsidein"
end

# tweet the weather everyday at 20:00 for each US timezone
# task will only enqueue zips where it is 20:00
#every 1.hour do
#  rake "twitzip:tweet_weather"
#end

# update the mentions every 5 minutes
#every 5.minutes do
#  rake "twitzip:update_mentions"
#end

# Tuesday morning update the Twitter followers
#every ['Tuesday'], :at => '01:00' do
#  rake "twitzip:update_followers"
#end

# Tuesday morning update the Twitter followers count
#every ['Tuesday'], :at => '01:00' do
#  rake "twitzip:update_followers_count"
#end

# crawl all zips at 1am except on Tuesday
#every ['Sunday','Monday','Wednesday','Thursday','Friday','Saturday'], :at => "01:00" do
#  rake "twitzip:crawl_all"
#end

# crawl all zips and follow followers at 1am except on Tuesday
every ['Sunday','Monday','Wednesday','Thursday','Friday','Saturday'], :at => "01:00" do
  rake "twitzip:crawl_outsidein_and_follow"
end

# crawl Fwix every day at 5 minutes past midnight
#every 1.day, :at => ['00:05'] do
#  rake "twitzip:crawl_fwix"
#end

# update the Commission Junction links for each GrouponDivision
#every 1.day do
#  rake "twitzip:update_cj_links"
#end

# every hour tweet the Groupon deals
# will only tweet for the cities where the local time matches the desired tweet time
#every 1.hour do
#  rake "twitzip:tweet_groupon"
#end

# every week update the list of groupon cities and the associated zips
#every 1.week do
#  rake "twitzip:update_groupon"
#end

# check for new FEMA IPAWS alerts
every 5.minutes do 
  rake "twitzip:fema_ipaws"
end

# check for new FEMA IPAWS alerts
every 5.minutes do 
  rake "twitzip:noaa_alerts"
end

# get new data from Tandem
every 1.day, :at => ['00:05'] do
  runner 'Tandem.populate'
  runner 'TwitterZip.export_json'
end

# search for #twitzip mentions that tweetstream missed
every 10.minutes do
  runner 'TwitterMention.search'
end

# tweet any pending zip messages
every 15.minutes do
  rake "twitzip:tweet"
end

# every day follow our followers
#every 1.day, :at => '04:00' do
#  rake "twitzip:follow_followers"
#end

# every day delete delayed_jobs with errors
every 1.day, :at => ['09:00'] do
  rake "twitzip:delete_jobs_by_error['Status is over 140 characters']"
  rake "twitzip:delete_jobs_by_error['Status is a duplicate']"
  rake "twitzip:delete_jobs_by_error['Could not follow user: Sorry, this account has been suspended']"
end

# every day delete old ShortUrls
every 1.day do
  rake "twitzip:delete_old_short_urls"
end

# every day delete old ZipMessages
every 1.day do
  rake "twitzip:delete_old_zip_messages"
end

# every 6 months send the keepalive tweet
every 6.months do
 rake "twitzip:tweet_keep_alive"
end
