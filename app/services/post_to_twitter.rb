class PostToTwitter
  attr_accessor :post, :user

  def initialize(params)
    @user = params[:user]
    @post = params[:post]
  end

  def create
    twitter_post(post, user)
  end

  def twitter_post(post, user)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['twitter_key']
      config.consumer_secret     = ENV['twitter_secret']
      config.access_token        = Identity.where(user_id: user).first.oauth_token
      config.access_token_secret = Identity.where(user_id: user).first.oauth_secret
    end
    client.update(post)
  end
end
