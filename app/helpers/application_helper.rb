module ApplicationHelper
  def authorized?
    @list_owner_id == @current_user_id
  end

  def show?
    params[:action] == 'show'
  end
end
