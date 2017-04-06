class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy update edit send_tweet]

  def index
    @posts = Post.where(user_id: current_user.id).order(:created_at)
  end

  def new
    @post = Post.new
  end

  def show; end

  def send_tweet
    twitter_post(@post.body, @post.user_id)
    redirect_to root_path
  end

  def create
    @post = Post.new(post_params)
    if @post.save!
      redirect_to @post
    else
      render :new
    end
  end

  def twitter_post(post, user)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['twitter_key']
      config.consumer_secret     = ENV['twitter_secret']
      config.access_token        = Identity.find(user).oauth_token
      config.access_token_secret = Identity.find(user).oauth_secret
    end
    client.update(post)
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    whitelist = params.require(:post).permit(:body)
    whitelist.merge(user_id: current_user.id)
  end
end
