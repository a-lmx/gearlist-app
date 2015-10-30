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

  def from_search?
    params[:commit] == 'Continue with selected item'
  end

  def gms_to_oz(gms)
    (gms * 0.035274).round(1)
  end

  def gms_to_lbs_oz(gms)
    total_ounces = gms_to_oz(gms)
    lbs = (total_ounces / 16).floor
    if lbs > 0
      lb_form = lbs == 1 ? 'lb.' : 'lbs.'
      ounces = (total_ounces % 16).round(1)
      lbs_oz = "#{lbs} #{lb_form} #{ounces} oz."
    else
      lbs_oz = "#{total_ounces} oz."
    end

    lbs_oz
  end
end
