class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
    userid = params[:id]
    begin
      @user = Integer(userid)
    rescue ArgumentError
      @user = nil
    end

    begin
      return @user if @user.nil?

      @user = User.find(userid)
    rescue ActiveRecord::RecordNotFound
      @user = nil
    end
  end
end
