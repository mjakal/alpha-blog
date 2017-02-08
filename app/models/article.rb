class Article < ActiveRecord::Base
  belongs_to :user
  has_many :article_categories
  has_many :categories, through: :article_categories
  
  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :description, presence: true, length: {minimum: 5, maximum: 300}
  validates :user_id, presence: true

  def self.search_articles(search, page)
    where("title LIKE ?", "%#{search}%").paginate(page: page, per_page: 5)
  end
end