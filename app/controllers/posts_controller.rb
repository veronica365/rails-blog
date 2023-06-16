class PostsController < ApplicationController
  def index
    begin
      userid = params[:user_id]
      @posts = Integer(userid) rescue nil
      return @posts if @posts.nil?

      @user = User.find(@posts)
      @posts = @user.posts
    rescue ActiveRecord::RecordNotFound => e
      @posts = nil
    end
  end

  def show
    begin
      userid = Integer(params[:user_id]) rescue nil
      @post = Integer(params[:id]) rescue nil
      return @post if @post.nil? || userid.nil?

      @post = Post.find(@post)
      if @post.author.id != userid
        @post = nil
        return
      end
    rescue ActiveRecord::RecordNotFound => e
      @post = nil
    end
  end
end
