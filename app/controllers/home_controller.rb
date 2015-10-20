class HomeController < ApplicationController
  def index
    @list = list_details(3)
    @sections = sections(3)
  end

  def list_details(list_id)
    url = 'http://localhost:3000/api/v1/lists/' + list_id.to_s
    response = HTTParty.get(url)
    return response.parsed_response
  end

  def sections(list_id)
    url = 'http://localhost:3000/api/v1/lists/' + list_id.to_s + '/sections'
    response = HTTParty.get(url)
    return response.parsed_response
  end
end
