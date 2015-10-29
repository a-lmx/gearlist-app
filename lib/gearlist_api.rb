class GearlistApi
  attr_accessor :auth_header

  if Rails.env.production?
    GEARLIST_URI = 'http://www.kitgearlist.com/api/v1'
  else
    GEARLIST_URI = 'http://localhost:3000/api/v1'
  end

  def initialize(token)
    @auth_header = {
      "Authorization" => "Token token=\"#{token}\""
    }
  end

  def post(url_snippet, body)
    url = GEARLIST_URI + url_snippet
    response = HTTParty.post(url, body: body, headers: auth_header)
    return response.parsed_response
  end

  def put(url_snippet, body)
    url = GEARLIST_URI + url_snippet
    response = HTTParty.put(url, body: body, headers: auth_header)
    return response.parsed_response
  end

  def delete(url_snippet)
    url = GEARLIST_URI + url_snippet
    response = HTTParty.delete(url, headers: auth_header)
    return response.parsed_response
  end

  def get_user_lists(user_id)
    url = GEARLIST_URI + '/users/' + user_id.to_s + '/lists'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def lists(url_param)
    url = GEARLIST_URI + url_param
    response = HTTParty.get(url, headers: auth_header)
    response.parsed_response
  end

  def get_list_details(list_id)
    url = GEARLIST_URI + '/lists/' + list_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_list_sections(list_id)
    url = GEARLIST_URI + '/lists/' + list_id.to_s + '/sections'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_section_items(section_id)
    url = GEARLIST_URI + '/list-sections/' + section_id.to_s + '/items'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_item_details(item_id)
    url = GEARLIST_URI + '/items/' + item_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_raw_item_details(item_id)
    url = GEARLIST_URI + '/items/raw/' + item_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def search_items(query_term)
    url = GEARLIST_URI + '/items/search?q=' + query_term
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_sections
    url = GEARLIST_URI + '/sections'
    response = HTTParty.get(url, headers: auth_header)
    response.parsed_response
  end

end
