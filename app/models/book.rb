class Book < ApplicationRecord
  attr_accessor :tag_list
  after_save :tag_update
  after_find :to_tag_list
  has_many :book_tags
  has_many :tags, through: :book_tags

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  #ソート機能
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  private

  def tag_update
    old_tags = self.tags.pluck(:name)
    tags = self.tag_list.gsub(/[[:space:]]/, "").split(",").uniq

    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      self.book_tags.find_or_create_by(tag_id: tag.id)
    end

    delete_tags = old_tags - tags
    delete_tags.each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      book_tag = self.book_tags.find_by(tag_id: tag.id)
      if tag.book_tags.size <= 1
        tag.destroy
      else
        book_tag.destroy
      end
    end
  end

  def to_tag_list
    self.tag_list = self.tags.pluck(:name).join(", ")
    self
  end
end
