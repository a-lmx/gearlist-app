require 'gearlist_api'
require 'gearlist_mapper'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :_reload_libs, :if => :_reload_libs?

  before_action :initialize_api, :user_lists, :current_user_id, :require_signin

  MESSAGES = {
    not_yo_list_edit: "You cannot edit someone else's Gear List.",
    not_yo_list_delete: "You cannot delete someone else's Gear List.",
    items_search_failure: "We didn't find any matching items. Please enter the item data manually."
  }

  TITLE = "Penguin Gear Lists"

  private

  def initialize_api
    @gearlist_api = GearlistApi.new(session[:token])
  end

  def user_lists
    @user_lists = @gearlist_api.get_user_lists(session[:user_id])
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
      redirect_to login_path
    end
  end

  #############################################################################
  # For auto-reloading /lib files
  def _reload_libs
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?
    defined? RELOAD_LIBS
  end
end
