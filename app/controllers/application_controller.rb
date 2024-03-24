class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top,:about] 
  before_action :configure_permitted_parameters, if: :devise_controller?

  
  
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
  def after_sign_out_path_for(resource)
    root_path
  end

  def create
    # １. データを受け取り新規登録するためのインスタンス作成
    @book = Book.new(book_params)
    # 2. データをデータベースに保存するためのsaveメソッド実行
    if @book.save
      # 3. フラッシュメッセージを定義し、詳細画面へリダイレクト
      flash[:notice] = "投稿に成功しました。"
      redirect_to books_path(@book.id)
    else
      render :new
    end
  end
 
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

end