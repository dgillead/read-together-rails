class BookDiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_discussion, only: [:show, :destroy, :invite]

  def index
    @book_discussions = []
    BookDiscussion.find_each do |discussion|
      if discussion.discussion_participants.include?(current_user.email)
        @book_discussions << discussion
      end
    end
  end

  def invite
    @invite_email = params[:email]
    @book_discussion.discussion_participants.push(@invite_email)
    if @book_discussion.save
      flash.now[:success] = "User has been invited!"
      render :show
    end
  end

  def search
    @books = FindBooks.new(query: params[:q]).call
    if @books == []
      flash.now[:error] = "Sorry, we couldn\'t find any books for that search."
      render :search
    end
  end

  def create
    @book_discussion = current_user.book_discussions.new(book_params)
    if @book_discussion.save
      redirect_to @book_discussion
    else
      render :search
    end
  end

  def show
  end

  def destroy
    @book_discussion.destroy
    redirect_to '/book_discussions'
  end

  private

  def find_discussion
    @book_discussion = BookDiscussion.find_by(id: params[:id])
  end

  def book_params
    params.permit(:book_title, :book_author, :book_image_url)
  end

end
