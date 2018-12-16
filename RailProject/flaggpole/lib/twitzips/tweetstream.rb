require 'rubygems'
require 'tweetstream'
require File.dirname(__FILE__) + '/../../config/environment.rb'
require 'logger'

# TODO on startup do a search to find any previous mentions that were missed

log = Logger.new(File.dirname(__FILE__) + '/../../log/tweetstream.log')
# test with zip 00604

@client = TweetStream::Client.new('twitzipbot','tweetpole')
#@client = TweetStream::Daemon.new('twitzipbot','tweetpole','tweetstream')

@client.on_delete do |status_id, user_id|
  # ...
end

@client.on_limit do |skip_count|
  # ...
end

@client.on_error do |message|
  # ...
end

@client.track('#twitzip') do |m|
  #puts "#{m.user.screen_name} | #{m.id} | #{m.text}"
  log.info "#{Time.now} | #{m.user.screen_name} | #{m.id} | #{m.text}"
  
  #zips = m.text.scan(/\s+(@\d{5})\s+/)
  #next if zips.empty?
  #zip = zips.first.first
  
  # do not retweet retweets to prevent loops
  #next if m.keys.include? :retweeted_status
  
  # check if tweet mentions a zip
  unless m.text =~ /(^|\s+)@(\d{5})(\s+|$)/
    log.info "Does not mention a TwitZip"
    next
  end
  zip = $2

  # find the TwitterZip
  tz = TwitterZip.find_by_zip(zip)
  if tz.nil?
    log.info "Could not find TwitterZip with zip #{zip}"
    next
  end

  # create a twitter_mention
  twitter_mention = tz.twitter_mentions.create(
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

  log.info "Created TwitterMention #{twitter_mention.id} #{twitter_mention.text}"

  # Enqueue retweet of twitter_mention with high priority
  Delayed::Job.enqueue(RetweetMentionJob.new(twitter_mention.id), 5)

end
