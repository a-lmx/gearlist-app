Rails.application.routes.draw do
  root 'home#index'

  get '/lists/:id', to: 'home#show', as: 'list' 
  get 'login', to: 'home#login', as: 'login'
end
