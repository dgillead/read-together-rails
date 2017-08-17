require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe BookDiscussionsController, type: :controller, vcr: true do
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

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new BookDiscussion' do
        sign_in(user)

        expect { post :create, params: { book_title: 'The Book', book_author: 'me', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg' } }.to change{ BookDiscussion.count }.by(1)
      end

      it 'assigns newly created book discussion as @book_discussion' do
        sign_in(user)

        post :create, params: { book_title: 'The Book', book_author: 'me', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg' }

        expect(assigns(:book_discussion)).to be_a(BookDiscussion)
        expect(assigns(:book_discussion)).to be_persisted
      end

      it 'redirects to the created discussion' do
        sign_in(user)

        post :create, params: { book_title: 'The Book', book_author: 'me', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg' }

        expect(response).to redirect_to(BookDiscussion.last)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested book discussion' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)

      expect{ delete :destroy, params: { id: book_discussion.to_param } }.to change{ BookDiscussion.count }.by(-1)
    end

    it 'redirects to the book discussions index' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)

      delete :destroy, params: { id: book_discussion.to_param }

      expect(response).to redirect_to('/book_discussions')
    end

    it "removes the discussion from all user\'s saved discussions" do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)
      book_discussion_id = book_discussion.id
      user.saved_discussions.push(book_discussion_id)

      delete :destroy, params: { id: book_discussion.to_param }
      user.reload

      expect(user.saved_discussions).to_not include(book_discussion_id)
    end
  end

  describe 'GET #change_status' do
    it 'changes the status of the book discussion' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)

      get :change_status, params: { id: book_discussion.to_param }
      book_discussion.reload

      expect(book_discussion.status).to eq('public')
    end
  end

  describe 'GET #save' do
    it 'saves the public discussion for the user' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)
      book_discussion[:status] = 'public'

      expect { get :save, params: { id: book_discussion.to_param } }.to change{ user.reload.saved_discussions.count }.by(1)
    end
  end

  describe 'GET #remove_saved' do
    it "removes the public discussion from the user\'s saved discussions" do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)
      book_discussion[:status] = 'public'

      get :save, params: { id: book_discussion.to_param }

      expect { get :remove_saved, params: { id: book_discussion.to_param } }.to change{ user.reload.saved_discussions.count }.by(-1)
    end
  end

  describe 'GET #search_discussions' do
    it 'returns a list of public discussions that contains the search query' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)
      book_discussion[:status] = 'public'

      get :search_discussions, params: { q: 'book' }

      expect(response.body).to include('book')
    end

    it 'displays a message notifying user if search returned no results' do
      sign_in(user)
      valid_private_book_attributes[:user_id] = user.id
      book_discussion = BookDiscussion.create!(valid_private_book_attributes)
      book_discussion[:status] = 'public'

      get :search_discussions, params: { q: 'asdfasdf' }

      expect(response.body).to include('No discussions could be found')
    end
  end

  DatabaseCleaner.clean
end
