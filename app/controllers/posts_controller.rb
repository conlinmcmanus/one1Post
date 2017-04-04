class PostsController < ApplicationController
  before_action :find_post, only: %i[destroy update edit]

  def index
    @posts = Post.where(user_id: current_user.id).order(:created_at)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path
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

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    whitelist = params.require(:post).permit(:body)
    whitelist.merge(user_id: current_user.id)
  end
end
