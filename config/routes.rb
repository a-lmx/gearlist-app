Rails.application.routes.draw do
  root 'home#index'

  get '/lists/:id', to: 'home#show', as: 'list' 

  get '/lists/new', to: 'home#new_list', as: 'new_list'
  post '/lists/new', to: 'home#create_list', as: 'create_list'

  # get 'login', to: 'home#login', as: 'login'
end
