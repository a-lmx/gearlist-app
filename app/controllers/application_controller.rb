class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :user_lists, :current_user_id, :require_signin

  # BASE_URI = 'http://localhost:3000/api/v1'
  # BASE_URI = 'http://www.penguingearlist.com'+'/api/v1'
  BASE_URI = 'http://gearlist-app-prod.elasticbeanstalk.com' + '/api/v1'

  MESSAGES = {
    not_yo_list: "You cannot edit someone else's Gear List."
  }

  private

  # TODO: have this be wiped out when user logs out
  # or maybe just make a new call each time -> you'd want it to update when a new list is created
  def user_lists
    @user_lists = get_user_lists(session[:user_id])
  end

  def get_user_lists(user_id)
    url = BASE_URI + '/users/' + user_id.to_s + '/lists'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_list_details(list_id)
    url = BASE_URI + '/lists/' + list_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def auth_header
    token = session[:token]
    auth_header = {
      "Authorization" => "Token token=\"#{token}\""
    }

    return auth_header
  end

  def current_user_id
    @current_user_id = session[:user_id]
  end

  def require_signin
    unless @current_user_id
      # flash[:errors] = MESSAGES[:not_signed_in]
      redirect_to login_path
    end
  end
end
