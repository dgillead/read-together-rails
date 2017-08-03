Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'
  get '/search', to: 'book_discussions#search'
  get '/invite', to: 'book_discussions#invite'
  get '/all', to: 'book_discussions#all'
  get '/status', to: 'book_discussions#change_status'
  get '/save', to: 'book_discussions#save'
  get '/remove_saved', to: 'book_discussions#remove_saved'

  resources :book_discussions
  resources :sections
  resources :comments

  get '*unmatched_route', to: 'application#not_found'

  default_url_options :host => "localhost:3000"
end
