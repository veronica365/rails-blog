class CommentsController < ApplicationController
  before_action :current_post

  def new
    @comment = Comment.new
  end

  def create
    @comments = @current_post.comments.new(comment_params)
    @comments.post_id = @current_post.id
    @comments.author_id = @current_user.id

    if @comments.save
      redirect_to "/users/#{@current_post.author_id}/posts/#{@current_post.id}"
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
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
