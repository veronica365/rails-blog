class PostsController < ApplicationController
  check_authorization
  skip_authorization_check

  def index
    @user = User.find(@user_id)
    @posts = @user.posts.includes(:comments)
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.find(@post_id)
    # TODO: Add check to validate if the user_id in url matches the post author
    # Useless but its what we want to ensure post_author and current user in the url match
    # @post = nil unless @post.author.id == userid
    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    if @post.save
      redirect_to "/users/#{current_user.id}/posts"
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(@post)
    return redirect_to "/users/#{current_user.id}/posts" if @post.destroy

    render 'errors/404', value: 'The post no longer exists'
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
