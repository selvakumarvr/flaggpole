module Twitter
  def self.grade(screen_name)
    url = "http://tweetblocker.com/api/username/#{screen_name}.json"
    res = Net::HTTP.get_response(URI.parse(url))
    spam_score = JSON.parse(res.body)['candidate']['score']
  end

  class Base
    # file should respond to #read and #path
    def update_profile_image(file)
      perform_post('/account/update_profile_image.json', build_multipart_bodies(:image => file))
    end

    def all_followers
      followers = []
      next_cursor = -1
      begin
        page = self.followers(:cursor => next_cursor)
        followers += page.users
        next_cursor = page.next_cursor
      end while next_cursor != 0
      followers
    end
  end
end
