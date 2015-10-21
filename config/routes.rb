Rails.application.routes.draw do
  root 'lists#index'

  resources :lists, only: [:index, :show, :new, :create] do
    get '/items', to: 'items#add', as: 'items'
  end
end
