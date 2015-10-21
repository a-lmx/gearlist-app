Rails.application.routes.draw do
  root 'lists#index'

  resources :lists, only: [:index, :show, :new, :create]
end
