class TwitterFollower < ActiveRecord::Base
  belongs_to :twitter_zip, :counter_cache => true
end
