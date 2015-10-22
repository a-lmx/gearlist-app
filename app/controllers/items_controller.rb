class ItemsController < ApplicationController
  def new
    @item = Item.new
    @list_id = params[:list_id]
    render :new
  end

  def create
    list_id = params["list_id"]
    item = params["item"]
    url = ApplicationController::BASE_URI + '/lists/'+ list_id + '/items'
    options = {
      body: {
        item: {
          name: item["name"],
          weight: item["weight"],
          category: item["category"]
        },
        section: item["section"],
        list_id: list_id
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
