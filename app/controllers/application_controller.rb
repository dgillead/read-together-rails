class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def not_found
    redirect_to '/404'
  end

  def after_sign_in_path_for(resource)
    book_discussions_path
  end
end
