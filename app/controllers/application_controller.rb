require 'gearlist_api'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :_reload_libs, :if => :_reload_libs?

  before_action :initialize_api, :user_lists, :current_user_id, :require_signin

  if Rails.env.production?
    BASE_URI = 'http://gearlist-api-prod.elasticbeanstalk.com' + '/api/v1'
  else
    BASE_URI = 'http://localhost:3000/api/v1'
  end
  # BASE_URI = 'http://www.penguingearlist.com'+'/api/v1'

  MESSAGES = {
    not_yo_list_edit: "You cannot edit someone else's Gear List.",
    not_yo_list_delete: "You cannot delete someone else's Gear List.",
    items_search_failure: "We didn't find any matching items. Please enter the item data manually."
  }

  private

  def initialize_api
    @gearlist_api = GearlistApi.new(session[:token])
  end

  def user_lists
    @user_lists = @gearlist_api.get_user_lists(session[:user_id])
  end

  # def get_user_lists(user_id)
  #   url = BASE_URI + '/users/' + user_id.to_s + '/lists'
  #   response = HTTParty.get(url, headers: auth_header)
  #   return response.parsed_response
  # end

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

  def _reload_libs
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?
    defined? RELOAD_LIBS
  end
end
