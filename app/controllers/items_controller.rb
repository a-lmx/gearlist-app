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
    body_contents = {
      item: {
        name: item["name"],
        weight: item["weight"],
        category: item["category"]
      },
      section: item["section"],
      quantity: item["quantity"],
      list_id: list_id
    }
    response = HTTParty.post(
      url, 
      body: body_contents,
      headers: auth_header
    )
    # contents = response.parsed_response

    # if contents["success"]
    #   flash message yay
    # else
    #   flash message wah
    # end
    redirect_to list_path(list_id)
  end

  def edit
    item_info = get_item_details(params[:id])
    @item = Item.new(
      name:       item_info['name'],
      category:   item_info['category'],
      weight:     item_info['weight'],
      quantity:   item_info['quantity'],
      list_id:    params[:list_id],
      section:    item_info['section']
    )
  end

  ### From ListsController
  # def edit
  #   list_info = get_list_details(params[:id])

  #   unless list_info['user_id'].to_s == session[:user_id]
  #     flash[:errors] = MESSAGES[:not_yo_list]
  #     redirect_to root_path
  #   end

  #   @list = List.new(
  #     name: list_info['name'], 
  #     description: list_info['description'], 
  #     secret: list_info['secret'],
  #     user_id: list_info['user_id'],
  #     id: params[:id]
  #   )
  #   @user_id = session[:user_id]
  # end

  private

  def get_item_details(item_id)
    url = ApplicationController::BASE_URI + '/items/' + item_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def item_params
    params.require(:item).permit(:id, :section, :category, :name, :quantity, :weight, :list_id)
  end
end
