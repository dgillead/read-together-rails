class BookDiscussion < ApplicationRecord
  has_many :sections, dependent: :destroy
  belongs_to :user
end
