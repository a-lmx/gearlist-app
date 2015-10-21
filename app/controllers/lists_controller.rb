class ListsController < ApplicationController
  before_action :user_lists

  def index
    @lists = get_lists
  end

  def show
    @list = build_list(params[:id])
  end

  def new
    render :new
  end

  def create
    @user_id = ApplicatonController::DEFAULT_USER_ID
    # create hash to send to API here
  end

  private

  def build_list(list_id)
    list = {}

    details = get_list_details(list_id)
    list[:name]        = details["name"]
    list[:description] = details["description"]

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
    retrieved_lists = HTTParty.get(url).parsed_response

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
    response = HTTParty.get(url)
    return response.parsed_response
  end

  def get_list_sections(list_id)
    url = ApplicationController::BASE_URI + '/lists/' + list_id.to_s + '/sections'
    response = HTTParty.get(url)
    return response.parsed_response
  end

  def get_section_items(section_id)
    url = ApplicationController::BASE_URI + '/list-sections/' + section_id.to_s + '/items'
    response = HTTParty.get(url)
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
end
