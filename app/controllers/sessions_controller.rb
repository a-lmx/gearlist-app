class SessionsController < ApplicationController
  skip_before_action :user_lists, :current_user_id, :require_signin

  def new
    render :new
  end

  def create
    session[:user_id] = params["userId"]
    session[:token] = params["token"]

    render  json: { success: "You set the session user_id and token." }, 
            status: 200
  end
end
