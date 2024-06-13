Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get 'main_pages/top', to: 'main_pages#top'
  get 'main_pages/introduction', to: 'main_pages#introduction', as: 'introduction_main_pages'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
end
