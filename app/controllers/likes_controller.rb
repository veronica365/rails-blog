class LikesController < ApplicationController
  check_authorization
  skip_authorization_check
  before_action :current_post

  def new
    @like = Like.new
  end

  def create
    @like = @current_post.likes.new(author_id: current_user.id, post_id: @current_post.id)
    return redirect_to "/users/#{@current_post.author.id}/posts/#{@current_post.id}" if @like.save

    render.new
  end

  def current_post
    @current_post = Post.find(@post_id)
  end
end
