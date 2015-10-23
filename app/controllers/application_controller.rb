class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :user_lists

  BASE_URI = 'http://localhost:3000/api/v1'

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

  def auth_header
    token = session[:token]
    auth_header = {
      "Authorization" => "Token token=\"#{token}\""
    }

    return auth_header
  end
end
