class OauthsController < ApplicationController

  # skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if (@user = login_from(provider))
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        signup_and_login(provider)
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
      rescue ActiveRecord::RecordInvalid => e
        redirect_to login_path, alert: "アカウントの作成に失敗しました: #{e.record.errors.full_messages.join(', ')}"
      rescue StandardError => e
        redirect_to login_path, alert: "#{provider.titleize}アカウントでのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    ActiveRecord::Base.transaction do
      @user = create_from(provider)
      reset_session
      auto_login(@user)

      user_exercises = {}
      Exercise.all.each do |exercise|
        user_exercises[exercise.id] = 0
      end

      unless WorkoutSchedule.create_dummy_by_user(@user, user_exercises)
        raise ActiveRecord::Rollback
      end
    end
  end
end
