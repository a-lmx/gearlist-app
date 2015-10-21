Rails.application.routes.draw do
  root 'home#index'

  get '/lists/new', to: 'home#new_list', as: 'new_list'
  get '/lists/:id', to: 'home#show', as: 'list' 

  post '/lists/new', to: 'home#create_list', as: 'create_list'
end
