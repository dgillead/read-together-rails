class Section < ApplicationRecord
  validates :book_discussion_id, presence: true
  validates :title, presence: true

  belongs_to :book_discussion
end
