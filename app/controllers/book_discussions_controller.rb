class BookDiscussionsController < ApplicationController

  def search
    @book = FindBooks.new(query: params[:q]).call
    binding.pry
  end

end
