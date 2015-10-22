Rails.application.routes.draw do
  root 'lists#index'

  resources :lists, only: [:index, :show, :new, :create] do
    resources :items, only: [:new, :create]
  end

  get '/login', to: 'sessions#new', as: 'login'
end
