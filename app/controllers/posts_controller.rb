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
    # Post functionality to show a post by id by user by id
  end
end
