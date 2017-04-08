class PostToFacebook
  attr_accessor :post, :user

  def initialize(params)
    @user = params[:user]
    @post = params[:post]
  end

  def create
    facebook_post(post, user)
  end

  def facebook_post(post, user)
    client = Koala::Facebook::API.new(Identity.where(user_id: user).first.oauth_token)
    client.put_wall_post(post)
  end
end
