require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe SectionsController, type: :controller, vcr: true do
  render_views

  let(:user) { User.create!(first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf') }
  let(:book_discussion) { BookDiscussion.create!(book_title: 'The Book Title', book_image_url: 'https://images.gr-assets.com/books/1344371661m/6424171.jpg', book_author: 'me', status: 'public', discussion_participants: ['dg@gmail.com'], user_id: user.id) }

  let(:valid_section_attributes) { { title: 'Title' } }


  describe 'GET #new' do
    it 'assigns a section as @section' do
      sign_in(user)

      get :new, params: { book_discussion_id: book_discussion.to_param }

      expect(assigns(:section)).to be_a_new(Section)
    end
  end

  describe 'POST #create' do
    it 'creates the new section record and assigns it to @section' do
      sign_in(user)

      expect{ post :create, params: { book_discussion_id: book_discussion.to_param, section: valid_section_attributes } }.to change{ book_discussion.sections.count }.by(1)
    end

    it 'redirects to the book discussion the section belongs to' do
      sign_in(user)

      post :create, params: { book_discussion_id: book_discussion.to_param, section: valid_section_attributes }

      expect(response).to redirect_to(book_discussion)
    end
  end

  describe 'GET #show' do
    it 'shows the section' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(valid_section_attributes)

      get :show, params: { book_discussion_id: book_discussion.to_param, id: section.id }

      expect(response.body).to include('Title')
    end

    it 'shows the book discussion the section belongs to' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(valid_section_attributes)

      get :show, params: { book_discussion_id: book_discussion.to_param, id: section.id }

      expect(response.body).to include('The Book Title')
      expect(response.body).to include('me')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the selected product' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(valid_section_attributes)

      expect { delete :destroy, params: { book_discussion_id: book_discussion.to_param, id: section.id } }.to change{ book_discussion.sections.count }.by(-1)
    end

    it 'redirects to the book discussion the section belonged to' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(valid_section_attributes)

      delete :destroy, params: { book_discussion_id: book_discussion.to_param, id: section.id }

      expect(response).to redirect_to(book_discussion)
    end
  end

  describe 'GET #edit' do
    it 'shows a form with the existing section title' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(valid_section_attributes)

      get :edit, params: { book_discussion_id: book_discussion.to_param, id: section.id }

      expect(response.body).to include('Title')
      expect(response.body).to include('Update Section')
    end
  end

  describe 'PUT #update' do
    it 'updates the existing section' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(book_discussion_id: book_discussion.id, title: 'Title Old')

      put :update, params: { book_discussion_id: book_discussion.to_param, id: section.id, section: valid_section_attributes }
      section.reload

      expect(section.title).to eq('Title')
    end

    it 'does not allow the book discussion id to change' do
      sign_in(user)
      section = Section.create!(book_discussion_id: book_discussion.id, title: 'Title Old')
      attributes = valid_section_attributes.merge(book_discussion_id: 5)

      expect { put :update, params: { book_discussion_id: book_discussion.to_param, id: section.id, section: attributes } }.not_to change{ section.reload.book_discussion_id }
    end

    it 'redirects to the updated section' do
      sign_in(user)
      valid_section_attributes[:book_discussion_id] = book_discussion.id
      section = Section.create!(book_discussion_id: book_discussion.id, title: 'Title Old')

      put :update, params: { book_discussion_id: book_discussion.to_param, id: section.id, section: valid_section_attributes }

      expect(response).to redirect_to(section)
    end
  end

  DatabaseCleaner.clean
end
