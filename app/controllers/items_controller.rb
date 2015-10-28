class ItemsController < ApplicationController
  def new
    # add check for if params[:item_id]
    # => make call to API for item info, assign to @item
    @item = Item.new
    @list_id = params[:list_id]
    # make API call to get list of section names
    @sections = get_sections
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
    list_info = get_list_details(params[:list_id])
    unless list_info['user_id'].to_s == @current_user_id
      flash[:errors] = ApplicationController::MESSAGES[:not_yo_list]
      redirect_to root_path
    else
      item_info = get_item_details(params[:id])
      @sections = get_sections
      @item = Item.new(
        name:       item_info['name'],
        category:   item_info['category'],
        weight:     item_info['weight'],
        quantity:   item_info['quantity'],
        list_id:    params[:list_id],
        section:    item_info['section'],
        id:         params[:id]
      )
    end
  end

  def update
    url = ApplicationController::BASE_URI + '/items/' + item_params[:id]

    body_contents = {
      item: {
        id: item_params['id'],
        name: item_params['name'],
        weight: item_params['weight'],
        category: item_params['category']
      },
      section: item_params['section'],
      quantity: item_params['quantity'],
    }
    response = HTTParty.put(
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
    redirect_to list_path(params[:list_id])
  end

  def destroy
    list_info = get_list_details(params[:list_id])
    unless list_info['user_id'].to_s == @current_user_id
      flash[:errors] = ApplicationController::MESSAGES[:not_yo_list]
    else
      item_id = params[:id]
      url = ApplicationController::BASE_URI + '/items/' + params[:id]

      response = HTTParty.delete(
        url,
        body: { list_section_item_id: item_id },
        headers: auth_header
      )

      contents = response.parsed_response
      flash[:errors] = contents[:failure] if contents[:failure]  
    end

    redirect_to list_path(params[:list_id])
  end

  def search
    # search_url = build_items_search_url(params[:search])

    # make call to API with search term
    # get back up to 10 items matching that description and their weights and categories
    # select item, go back to new page, passing through item id
  end

  private

  def get_item_details(item_id)
    url = ApplicationController::BASE_URI + '/items/' + item_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_sections
    url = ApplicationController::BASE_URI + '/sections'
    response = HTTParty.get(url, headers: auth_header)
    section_objects = response.parsed_response
    section_objects.map { |section| [section['name'], section['name']] }
  end

  def item_params
    params.require(:item).permit(:id, :section, :category, :name, :quantity, :weight, :list_id)
  end
end
