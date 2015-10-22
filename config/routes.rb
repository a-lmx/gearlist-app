Rails.application.routes.draw do
  root 'lists#index'

  resources :lists, only: [:index, :show, :new, :create] do
    resources :items, only: [:new]
  end
end
