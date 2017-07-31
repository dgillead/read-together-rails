Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'
  get '/search', to: 'book_discussions#search'
  get '/invite', to: 'book_discussions#invite'

  resources :book_discussions
  resources :sections
  resources :comments
end
