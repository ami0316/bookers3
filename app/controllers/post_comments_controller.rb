class PostCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.book_id = @book.id
    comment.save
    # redirect_to book_path(book)
    @post_comment = PostComment.new
  end
  
  def destroy
    comment = PostComment.find(params[:id])
    @book = comment.book
    comment.destroy
    # redirect_to book_path(params[:book_id])
  end  
  
  

private

def post_comment_params
   params.require(:post_comment).permit(:comment)
end
end
