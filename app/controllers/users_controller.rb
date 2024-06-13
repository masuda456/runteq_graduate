class UsersController < ApplicationController
  def new
    @user = User.new
    @exercises = Exercise.all
  end

  def create
    user_exercises = params[:user].delete(:exercises)
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      WorkoutSchedule.create_dummy_by_user(@user, user_exercises)
      redirect_to main_pages_top_path, notice: 'ユーザー登録が完了しました。'
    else
      @exercises = Exercise.all
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
