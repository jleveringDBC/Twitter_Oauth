class TweetWorker 

  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.user


    twitter_instance = Twitter.configure do |config|
      config.oauth_token = user.oauth_token
      config.oauth_token_secret = user.oauth_secret
    end

    Twitter.update(tweet.content)   

    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
  end
end
