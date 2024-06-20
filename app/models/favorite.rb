class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book

  #同じ人が同じ投稿に何度もいいねができないように制限
  validates :user_id, uniqueness: {scope: :book_id}
end
