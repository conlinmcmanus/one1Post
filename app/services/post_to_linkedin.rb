class PostToLinkedin
  attr_accessor :post, :user

  def initialize(params)
    @user = params[:user]
    @post = params[:post]
  end

  def linkedin_post(post, user)
    client = LinkedIn::Client.new do |config|
      config.consumer_key        = ENV['linkedin_key']
      config.consumer_secret     = ENV['linkedin_secret']
    end
    client.authorize_from_access(Identity.where(user_id: user).first.oauth_token, Identity.where(user_id: user).first.oauth_secret)
    client.add_share(comment: post)
  end
end
