class LikesController < ApplicationController
  before_action :current_post
    
  def new
    @like = Like.new
  end

  def create
    @like = @current_post.likes.new(author_id: @current_user.id, post_id: @current_post.id)

    if @like.save
      redirect_to "/users/#{@current_user.id}/posts/#{@current_post.id}"
    else
      render.new
    end
  end

  def current_post
    @postid = params[:post_id]
    begin
      @postid = Integer(@postid)
    rescue ArgumentError
      @postid = nil
    end

    return redirect_to "/users/#{@current_user.id}/posts" unless @postid != nil
    @current_post = Post.find(@postid)
  end  
end
