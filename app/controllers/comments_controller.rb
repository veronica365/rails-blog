class CommentsController < ApplicationController
  before_action :authenticate_api_request, only: [:create]
  before_action :current_post

  def new
    @comment = Comment.new
  end

  def index
    @user = User.find(params[:user_id])
    @post = @user.posts.find(params[:post_id])
    @comments = @post.comments

    respond_to do |format|
      format.html
      format.json { render json: @comments }
    end
  end

  def create
    current_user ||= @api_user
    @comments = @current_post.comments.new(comment_params)
    @comments.post_id = @current_post.id
    @comments.author_id = current_user.id

    if @comments.save
      return render json: @current_post.comments unless request.format.html?

      redirect_to "/users/#{@current_post.author_id}/posts/#{@current_post.id}"
    else
      render :new
    end
  end

  def destroy
    @comment = Comment.find_by(id: @comment_id, post_id: @post_id)
    return redirect_to "/users/#{@user_id}/posts/#{@post_id}" if @comment.destroy

    render 'errors/404', value: 'The comment no longer exists'
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def current_post
    @current_post = Post.find(@post_id)
  end
end
