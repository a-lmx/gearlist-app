class GearlistApi
  attr_accessor :auth_header

  if Rails.env.production?
    GEARLIST_URI = 'http://gearlist-api-prod.elasticbeanstalk.com/api/v1'
  else
    GEARLIST_URI = 'http://localhost:3000/api/v1'
  end

  def initialize(token)
    @auth_header = {
      "Authorization" => "Token token=\"#{token}\""
    }
  end

  def get_user_lists(user_id)
    url = GEARLIST_URI + '/users/' + user_id.to_s + '/lists'
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end

  def get_list_details(list_id)
    url = GEARLIST_URI + '/lists/' + list_id.to_s
    response = HTTParty.get(url, headers: auth_header)
    return response.parsed_response
  end
end
