class TwitZipBot
  def self.login
    httpauth = Twitter::HTTPAuth.new('twitzipbot', 'tweetpole')
    client = Twitter::Base.new(httpauth)
  end
  
  def self.reply(in_reply_to_status_id, screen_name, status)
    status = "@#{screen_name} #{status}"
    client = self.login
    client.update(status, :in_reply_to_status_id => in_reply_to_status_id)
  end
end