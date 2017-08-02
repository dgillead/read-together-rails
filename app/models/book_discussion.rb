class BookDiscussion < ApplicationRecord
  validates :user_id, presence: true
  validates :book_title, presence: true
  validates :book_image_url, presence: true
  validates :book_author, presence: true
  validates :status, presence: true

  has_many :sections, dependent: :destroy
  belongs_to :user
end
