class User < ActiveRecord::Base
  has_many :tweets


  def tweet(status, time)
    tweet = tweets.create!(:content => status)
    TweetWorker.perform_in(time, tweet.id)
  end

end
