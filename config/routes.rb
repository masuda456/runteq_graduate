Rails.application.routes.draw do
  get 'oauths/oauth'
  get 'oauths/callback'

  root 'introductions#show'

  # ログイン
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # シングルサインオン
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  # ユーザー
  resources :users, only: [:new, :create, :edit, :update]

  get 'workout_schedule_calendar', to: 'workout_schedules#calendar'

  # スケジュール
  get 'main', to: 'workout_schedules#new'

  resources :workout_schedules do
    collection do
      get :search
      get :load_more
    end
  end

  # push
  post 'notifications/subscribe', to: 'notifications#subscribe'
  # get 'notifications/subscribe', to: 'notifications#subscribe'

end
