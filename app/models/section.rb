class Section < ApplicationRecord
  has_many :comments
  belongs_to :book_discussion
end
