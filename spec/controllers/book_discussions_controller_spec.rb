require 'rails_helper'

RSpec.describe BookDiscussionsController, type: :controller do
  render_views

  let(:valid_user_attributes) {
    { first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf' }
  }

  let(:valid_book_attributes) {
    { book_title: 'The Book Title', book_image_url: 'www.bookimage.com', book_author: 'me', status: 'public', discussion_participants: ['dg@gmail.com'] }
  }

  let(:invalid_book_attributes) {
    { book_title: nil }
  }

  describe 'GET #index' do
    it 'assigns the discussions the user is included in in @book_discussions' do
      user = User.create!(valid_user_attributes)
      binding.pry
      book_discussion = BookDiscussion.create!(valid_book_attributes)

      get :index

      expect(assigns(:book_discussions)).to eq([book_discussion])
    end
  end
end
