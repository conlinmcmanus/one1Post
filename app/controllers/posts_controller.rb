class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy update edit twitter_post linkedin_post facebook_post]

  def index
    @posts = Post.where(user_id: current_user.id).order(:created_at)
  end

  def new
    @post = Post.new
  end

  def show
    @providers = linked_accounts
  end

  def create
    @post = Post.new(post_params)
    if @post.save!
      redirect_to @post
    else
      render :new
    end
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

  def linked_accounts
    providers_array = []
    User.where(id: current_user).first.providers.each do |i|
      providers_array << i.name
    end
    providers_array
  end

  %w[twitter facebook linkedin].each do |provider|
    class_eval %{
      def #{provider}_post
        if PostTo#{provider.capitalize}.new(post: @post.body, user: @post.user_id).create
          redirect_to @post, notice: 'Successfully shared post on #{provider.capitalize}!'
        else
          redirect_to @post, notice: 'Something went wrong, please try again. If issue persists attempt to unlink and relink account.'
        end
      end
    }
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
