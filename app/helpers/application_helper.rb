module ApplicationHelper
  def authorized?
    @list_owner_id == @current_user_id
  end

  def show?
    params[:action] == 'show'
  end

  def search?
    params[:action] == 'search'
  end

  def gms_to_oz(gms)
    number_with_precision((gms * 0.035274), precision: 1)
  end
end
