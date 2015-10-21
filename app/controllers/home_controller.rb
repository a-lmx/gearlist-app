class HomeController < ApplicationController
  def index
    @list = list_details(3)
    @complete_list = list_items(3)
    # @sections = sections(3)
  end

  def list_details(list_id)
    url = 'http://localhost:3000/api/v1/lists/' + list_id.to_s
    response = HTTParty.get(url)
    return response.parsed_response
  end

  def list_items(list_id)
    url = 'http://localhost:3000/api/v1/lists/' + list_id.to_s + '/items_by_section'
    response = HTTParty.get(url)
    return response.parsed_response
  end

  def sections(list_id)
    url = 'http://localhost:3000/api/v1/lists/' + list_id.to_s + '/sections'
    response = HTTParty.get(url)
    return response.parsed_response
  end
end

# to display list:
# => get list details
# => get list_sections
# => for each list_section
  # => get list_section_items
  # => subtotal section
# => calculate total weight of all list_sections_items
