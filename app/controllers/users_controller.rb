class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    begin
      userid = params[:id]
      @user = Integer(userid) rescue nil
      return @user if @user.nil?

      @user = User.find(userid)
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
    end
  end
end
