class UsersController < ApplicationController
  check_authorization
  skip_authorization_check

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(@user_id)
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
end
