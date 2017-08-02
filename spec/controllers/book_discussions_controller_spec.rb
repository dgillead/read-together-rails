require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe BookDiscussionsController, type: :controller do
  render_views

  let(:valid_user_attributes) {
    { first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf' }
  }

  let(:user) {
    User.create!(valid_user_attributes)
  }

  let(:valid_public_book_attributes) {
    { book_title: 'The Book Title', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg', book_author: 'me', status: 'public', discussion_participants: ['dg@gmail.com'] }
  }

  let(:valid_private_book_attributes) {
    { book_title: 'The Book Title Private', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg', book_author: 'me2', status: 'private', discussion_participants: ['dg123@gmail.com'] }
  }


  let(:invalid_book_attributes) {
    { book_title: nil }
  }

  describe 'GET #index' do
    it 'assigns the discussions the user is included in in @book_discussions' do
      sign_in(user)
      valid_public_book_attributes[:user_id] = user.id
      valid_private_book_attributes[:user_id] = user.id
      book_discussion_one = BookDiscussion.create!(valid_public_book_attributes)
      book_discussion_two = BookDiscussion.create!(valid_private_book_attributes)

      get :index

      expect(assigns(:book_discussions)).to eq([book_discussion_one])
    end
  end

  describe 'GET #all' do
    it 'assigns all of the public discussions to @book_discussions' do
      sign_in(user)
      valid_public_book_attributes[:user_id] = user.id
      valid_private_book_attributes[:user_id] = user.id
      book_discussion_one = BookDiscussion.create!(valid_public_book_attributes)
      book_discussion_two = BookDiscussion.create!(valid_private_book_attributes)

      get :all

      expect(assigns(:book_discussions)).to eq([book_discussion_one])
    end
  end

  DatabaseCleaner.clean
end
