class ListsController < ApplicationController
  MESSAGES = {
    # create_success: "You have successfully created a new recipe.",
    # create_fail: "There was a problem with your new recipe. Please try again.",
    # update_success: "You have successfully updated your recipe.",
    # update_fail: "There was a problem with your update. Please try again.",
    # destroy_success: "You have successfully deleted the recipe.",
    # destroy_fail: "There was a problem with your recipe deletion. Please try again.",
    # cookbook_fail: "Saving this recipe to that cookbook did not work. Please try again. ",
    not_yo_list: "You cannot edit someone else's Gear List."
  }

  def index
    @lists = get_lists
  end

  def show
    @list = build_list(params[:id])
    @list_owner_id = @list[:user_id].to_s
  end

  def new
    @list = List.new
    @user_id = session[:user_id]
    @submit_text = 'Create Gear List'
    render :new
  end

  def create
    url = ApplicationController::BASE_URI + '/lists'

    body_contents = { list: list_params }
    response = HTTParty.post(url, body: body_contents, headers: auth_header)
    contents = response.parsed_response

    if contents['success']
      list_id = contents['list_id']
      redirect_to list_path(list_id)
    else
      redirect_to new_list_path
    end
  end

  def edit
    list_info = get_list_details(params[:id])

    if list_info['user_id'] != session[:user_id]
      flash[:errors] = MESSAGES[:not_yo_list]
      redirect_to root_path
    end

    @list = List.new(
      name: list_info['name'], 
      description: list_info['description'], 
      secret: list_info['secret'],
      user_id: list_info['user_id'],
      id: params[:id]
    )
    @user_id = session[:user_id]
    @submit_text = 'Update Gear List'
  end

  def update
    url = ApplicationController::BASE_URI + '/lists/' + list_params[:id]

    body_contents = { list: list_params }
    response = HTTParty.put(url, body: body_contents, headers: auth_header)
    contents = response.parsed_response

    if contents['success']
      list_id = contents['list_id']
      redirect_to list_path(list_id)
    else
      render :edit
    end
  end

  private

  def build_list(list_id)
    list = {}

    details = get_list_details(list_id)
    list[:name]        = details["name"]
    list[:user_id]     = details["user_id"]
    list[:description] = details["description"]
    list[:secret]      = details["secret"]

    list[:sections] = get_list_sections(list_id)

    list[:sections].each do |section|
      section[:items] = get_section_items(section["id"])
      section[:subtotal] = weight_subtotal(section)
    end

    list[:total_weight] = total_weight(list)

    return list
  end

  def get_lists
    list_ids = []
    lists = []

    url = ApplicationController::BASE_URI + '/lists'
    retrieved_lists = HTTParty.get(url, headers: auth_header).parsed_response

    retrieved_lists.each do |list|
      list_ids.push(list["id"])
    end

    list_ids.each do |id|
      lists.push(build_list(id))
    end

    return lists
  end

  def get_list_details(list_id)
    url = ApplicationController::BASE_URI + '/lists/' + list_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_list_sections(list_id)
    url = ApplicationController::BASE_URI + '/lists/' + list_id.to_s + '/sections'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_section_items(section_id)
    url = ApplicationController::BASE_URI + '/list-sections/' + section_id.to_s + '/items'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def weight_subtotal(section)
    sum = 0
    section[:items].each do |item|
      sum += (item["weight"].to_i * item["quantity"].to_i)
    end

    return sum
  end

  def total_weight(list)
    sum = 0
    list[:sections].each do |section|
      sum += section[:subtotal]
    end

    return sum
  end

  def list_params
    params.require(:list).permit(:id, :user_id, :name, :description, :secret)
  end
end
