class ListsController < ApplicationController
  def index
    flash[:errors] = nil
    if params[:search]
      search_url = build_search_url(params[:search])
      @lists = GearlistMapper.get_lists(search_url, @gearlist_api)
      if @lists == nil || @lists.length == 0
        flash[:errors] = "Sorry, we can't find any lists relating to '#{params[:search]}', so here are all the lists."
        @lists = GearlistMapper.get_lists('/lists', @gearlist_api)
      end
    else
      @lists = GearlistMapper.get_lists('/lists', @gearlist_api)
    end
  end

  def show
    @list = GearlistMapper.build_list(params[:id], @gearlist_api)
    @list_owner_id = @list[:user_id].to_s
  end

  def new
    @list = List.new
    @user_id = session[:user_id]
  end

  def create
    url = '/lists'
    body = { list: list_params }

    response = @gearlist_api.post(url, body)

    if response['success']
      list_id = response['list_id']
      redirect_to list_path(list_id)
    else
      redirect_to new_list_path
    end
  end

  def edit
    list_info = @gearlist_api.get_list_details(params[:id])

    unless list_info['user_id'].to_s == @current_user_id
      flash[:errors] = ApplicationController::MESSAGES[:not_yo_list_edit]
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
  end

  def update
    url = ApplicationController::BASE_URI + '/lists/' + list_params[:id]

    body_contents = { list: list_params }
    response = HTTParty.put(
      url, 
      body: body_contents, 
      headers: auth_header
    )
    contents = response.parsed_response

    if contents['success']
      list_id = contents['list_id']
      redirect_to list_path(list_id)
    else
      render :edit
    end
  end

  def destroy
    list_info = @gearlist_api.get_list_details(params[:id])

    unless list_info['user_id'].to_s == @current_user_id
      flash[:errors] = ApplicationController::MESSAGES[:not_yo_list_delete]
      redirect_to list_path(params[:id])
    else
      url = ApplicationController::BASE_URI + '/lists/' + params[:id]
      response = HTTParty.delete(
        url,
        headers: auth_header
      )

      contents = response.parsed_response

      if contents['failure']
        flash[:errors] = 'Something went wrong. Please try again.'
      end

      redirect_to root_path
    end
  end

  private

  def build_search_url(query_string)
    '/lists/search?q=' + query_string
  end

  def list_params
    params.require(:list).permit(:id, :user_id, :name, :description, :secret)
  end
end
