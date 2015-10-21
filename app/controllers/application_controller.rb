class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :user_lists

  BASE_URI = 'http://localhost:3000/api/v1'
  DEFAULT_USER_ID = 1

  private

  # TODO: have this be wiped out when user logs out
  # or maybe just make a new call each time -> you'd want it to update when a new list is created
  def user_lists
    @user_lists ||= get_user_lists(DEFAULT_USER_ID) # TODO: change this hardcoded user_id!!!
  end

  def get_user_lists(user_id)
    url = BASE_URI + '/users/' + user_id.to_s + '/lists'
    response = HTTParty.get(url)
    return response.parsed_response
  end
end
