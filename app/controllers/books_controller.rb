class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book.id)
    else
      @user = current_user
      @books = Book.all
      render :index
    end

  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @post_comment = PostComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])  # データ（レコード）を1件取得
    book.destroy  # データ（レコード）を削除
    redirect_to '/books'  # 投稿一覧画面へリダイレクト
  end

  def update
    @book = Book.find(params[:id])

  if @book.update(book_params)

    # 4. フラッシュメッセージを定義
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book.id)
  else
      render :edit#この記述を追加
  end
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
  end

  private
  def book_params
      params.require(:book).permit(:title, :body)
  end


end