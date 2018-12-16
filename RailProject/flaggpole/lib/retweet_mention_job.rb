class RetweetMentionJob < Struct.new(:twitter_mention_id)
  def perform
    mention = TwitterMention.find(twitter_mention_id)
    mention.retweet
  end
end
