class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to main_path, notice: 'サインインに成功しました。'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが間違っています。'
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = 'サインアウトしました。'
    redirect_to root_path
  end
end
