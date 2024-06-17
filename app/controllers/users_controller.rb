class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def show
  @user = User.find(params[:id])
  @books = @user.books
  end


  def edit
  @user = User.find(params[:id])
  end


  def index
  @user = User.find(current_user.id)
  @book = Book.new
  @users = User.all
  end

  def update
  @user = User.find(params[:id])
  if @user.update(user_params)

    # 4. フラッシュメッセージを定義
      flash[:notice] = "Book was successfully created."
      redirect_to user_path(@user.id)
  else
      render :edit#この記述を追加
  end

  def create
  @user = User.new(user_params)
  @user.user_id = current_user.id
  if @user.save
      redirect_to user_path
  else
      render :new
  end
  end


  end




  private
  def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
  end


  # ここから追加
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
  # ここまで追加

  # ユーザーの編集画面へのURLを直接入力された場合にはメッセージを表示してユーザー詳細画面へリダイレクト
   def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end