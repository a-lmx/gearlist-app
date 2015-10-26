class SessionsController < ApplicationController
  skip_before_action :user_lists, :current_user_id, :require_signin

  def new
    render layout: 'login_layout'
  end

  def create
    session[:user_id] = params["userId"]
    session[:user_name] = params["userName"]
    session[:token] = params["token"]

    render  json: { success: "You set the session user_id and token." }, 
            status: 200
  end

  def destroy
    session[:user_id] = nil
    session[:token] = nil

    # flash message here - Thanks for using Penguin Gear Lists!
    redirect_to login_path
  end
end
