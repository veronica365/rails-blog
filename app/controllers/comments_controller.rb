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
    @comments = @current_post.comments.new(comment_params)
    @comments.post_id = @current_post.id
    @comments.author_id = current_user.id

    if @comments.save
      redirect_to "/users/#{@current_post.author_id}/posts/#{@current_post.id}"
    else
      render :new
    end
  end

  def destroy
    begin
      @comment = Integer(params[:id])
      @user = Integer(params[:user_id])
      @post = Integer(params[:post_id])
    rescue ArgumentError
      @comment = nil
      @post = nil
      @comment = nil
    end

    begin
      return @comment if @comment.nil? || @post.nil? || @user.nil?

      @comment = Comment.find_by(id: @comment, post_id: @post)
      if @comment.destroy
        redirect_to "/users/#{@user}/posts/#{@post}"
      else
        render 'errors/404', value: 'The comment no longer exists'
      end
    rescue ActiveRecord::RecordNotFound
      @post = nil
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

    return redirect_to "/users/#{current_user.id}/posts" if @postid.nil?

    @current_post = Post.find(@postid)
  end
end
