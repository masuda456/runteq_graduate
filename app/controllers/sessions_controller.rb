class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to main_pages_top_path, notice: 'サインインに成功しました。'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが間違っています。'
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = 'サインアウトしました。'
    redirect_to introduction_main_pages_path
  end
end
