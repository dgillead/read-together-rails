class BookDiscussionsController < ApplicationController

  def search
    @books = FindBooks.new(query: params[:q]).call
  end

end
