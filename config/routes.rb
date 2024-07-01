Rails.application.routes.draw do

  root 'introductions#show'

  # ログイン
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  # { turbo_method: :delete } って書いても何故かgetされる、これ以上時間かけられないので一旦getでログアウト処理をルーティング
  # get 'logout', to: 'sessions#destroy', as: 'logout'

  # ユーザー
  resources :users, only: [:new, :create, :edit, :update]

  # スケジュール
  get 'main', to: 'workout_schedules#new'

  resources :workout_schedules do
    collection do
      get :search
      get :load_more
    end
  end

end
