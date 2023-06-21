class PostsController < ApplicationController
  def index
    userid = params[:user_id]
    begin
      @posts = Integer(userid)
    rescue ArgumentError
      @post = nil
    end

    begin
      return @posts if @posts.nil?

      @user = User.find(@posts)
      @posts = @user.posts.includes(:comments)
    rescue ActiveRecord::RecordNotFound
      @posts = nil
    end
  end

  def show
    begin
      userid = Integer(params[:user_id])
      @post = Integer(params[:id])
    rescue ArgumentError
      @post = nil
    end

    begin
      return @post if @post.nil? || userid.nil?

      @post = Post.find(@post)
      @post = nil unless @post.author.id == userid
    rescue ActiveRecord::RecordNotFound
      @post = nil
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = @current_user
    if @post.save
      redirect_to "/users/#{@current_user.id}/posts"
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
