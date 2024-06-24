class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
    @exercises = Exercise.all
  end

  def create
    user_exercises = params[:user].delete(:exercises)
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      if @user.save
        auto_login(@user)
        if WorkoutSchedule.create_dummy_by_user(@user, user_exercises)
          redirect_to main_path, notice: 'ユーザー登録が完了しました。'
        else
          raise ActiveRecord::Rollback
        end
      else
        @exercises = Exercise.all
        flash[:alert] = 'ユーザー登録に失敗しました。'
        # Rails.logger.debug("User save failed: #{@user.errors.full_messages.to_sentence}")
        render :new
      end
    end
  rescue ActiveRecord::Rollback
    flash[:alert] = 'ユーザー登録に失敗しました。'
    @exercises = Exercise.all
    raise
    render :new
  end

  def edit
    @workout_schedule = @user.workout_schedules.first
    @workout_schedule_details = @workout_schedule.workout_schedule_details.order(:exercise_id) if @workout_schedule.present?
  end

  def update
    user_exercises = params[:user].delete(:exercises)
    ActiveRecord::Base.transaction do
      if @user.update(user_params_for_update)
        user_exercises.each do |id, one_rep_max_theoretical|
          detail = WorkoutScheduleDetail.find(id)
          unless detail.update(one_rep_max_theoretical: one_rep_max_theoretical)
            raise ActiveRecord::Rollback
          end
        end
        redirect_to @user, notice: 'プロフィールが更新されました。'
      else
        @workout_schedule = @user.workout_schedules.first
        render :edit
      end
    end
  rescue ActiveRecord::Rollback
    flash[:error] = 'プロフィールの更新に失敗しました。'
    @workout_schedule = @user.workout_schedules.first
    render :edit
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :gender, :only_same_gender_default)
  end

  def user_params_for_update
    # パスワードとパスワード確認が空白の場合、それらを削除して返す
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :gender, :only_same_gender_default).tap do |user_params|
      if user_params[:password].blank?
        user_params.delete(:password)
        user_params.delete(:password_confirmation)
      end
    end
  end
end
