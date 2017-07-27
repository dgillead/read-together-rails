class BookDiscussionsController < ApplicationController

  def search
    @book = FindBooks.new(query: params[:q]).call
  end

end
