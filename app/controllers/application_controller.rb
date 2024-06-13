class ApplicationController < ActionController::Base
  before_action :require_login, except: [:new, :create, :introduction]

  private

  def require_login
    unless logged_in?
      flash[:alert] = "ユーザー情報の取得に失敗しました。引き続きサービスをご利用の際は再度ログインをお願い致します。"
      redirect_to introduction_main_pages_path
    end
  end
end
