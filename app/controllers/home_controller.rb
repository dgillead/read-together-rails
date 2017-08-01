class HomeController < ApplicationController

  def index
    if current_user
      redirect_to '/book_discussions'
    end
  end
end
