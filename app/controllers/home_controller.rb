class HomeController < ApplicationController
  def index
    url = 'http://localhost:3000/api/v1/lists'
    @lists = HTTParty.get(url)
  end
end
