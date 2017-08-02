require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe SectionsController, type: :controller, vcr: true do
  render_views

  let(:user) { User.create!(first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf') }
  let(:book_discussion) { BookDiscussion.create!(book_title: 'The Book Title', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg', book_author: 'me', status: 'public', discussion_participants: ['dg@gmail.com'], user_id: user.id) }


  describe 'GET #new' do
    it 'assigns a section as @section' do
      sign_in(user)

      get :new, params: { book_discussion_id: book_discussion.to_param }

      expect(assigns(:section)).to be_a_new(Section)
    end
  end


  DatabaseCleaner.clean
end
