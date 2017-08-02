require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe BookDiscussionsController, type: :controller do
  render_views

  let(:valid_user_attributes) {
    { first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf' }
  }

  let(:valid_book_attributes) {
    { book_title: 'The Book Title', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg', book_author: 'me', status: 'public', discussion_participants: ['dg@gmail.com'] }
  }

  let(:invalid_book_attributes) {
    { book_title: nil }
  }


  describe 'GET #index' do
    it 'assigns the discussions the user is included in in @book_discussions' do
      user = User.create!(valid_user_attributes)
      sign_in(user)
      valid_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_book_attributes)

      get :index

      expect(assigns(:book_discussions)).to eq([book_discussion])
    end
  end

  DatabaseCleaner.clean
end
