class ItemsController < ApplicationController
  def new
    @item = Item.new
    @list_id = params[:list_id]
    render :new
  end

  def create
    list_id = params["item"]["list_id"]
    url = ApplicationController::BASE_URI + '/lists/'+ list_id + '/items'
    options = {
      body: {
        item: item_params
      }
    }
    raise
    response = HTTParty.post(url, options)
    # contents = response.parsed_response

    # if contents["success"]
    #   flash message yay
    # else
    #   flash message wah
    # end
    redirect_to list_path(list_id)
  end

  private

  def item_params
    params.require(:item).permit(:section, :category, :name, :quantity, :weight, :list_id)
  end
end
