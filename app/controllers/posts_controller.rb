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
      @posts = @user.posts
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
end
