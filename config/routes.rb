Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'
  get '/search', to: 'book_discussions#search'
  get '/invite', to: 'book_discussions#invite'
  get '/all', to: 'book_discussions#all'
  get '/status', to: 'book_discussions#change_status'

  resources :book_discussions
  resources :sections
  resources :comments

  get '*unmatched_route', to: 'application#not_found'
end
