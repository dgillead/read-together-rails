class BookDiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_discussion, only: [:show, :destroy, :invite, :change_status, :save, :remove_saved]

  def index
    @book_discussions = []
    BookDiscussion.find_each do |discussion|
      if discussion.discussion_participants.include?(current_user.email)
        @book_discussions << discussion
      end
    end
    @saved_discussions = []
    BookDiscussion.find_each do |discussion|
      if current_user.saved_discussions.include?(discussion.id)
        @saved_discussions << discussion
      end
    end
  end

  def invite
    @invite_email = params[:email]
    @book_discussion.discussion_participants.push(@invite_email)
    UserMailer.invitation(@invite_email).deliver_now!
    if @book_discussion.save
      flash.now[:success] = "User has been invited!"
      render :show
    end
  end

  def all
    @book_discussions = BookDiscussion.where("status = ?", 'public')
  end

  def save
    current_user.saved_discussions.push(@book_discussion.id)
    current_user.save
    flash.now[:success] = 'Discussion saved. It will now show up under your saved discussions.'
    render :show
  end

  def remove_saved
    current_user.saved_discussions.delete(@book_discussion.id)
    current_user.save
    flash.now[:success] = 'Discussion removed from your saved discussions.'
    render :show
  end

  def search
    @books = FindBooks.new(params[:q]).call
    if @books == []
      flash.now[:error] = "Sorry, we couldn\'t find any books for that search."
      render :search
    elsif @books == [1]
      flash.now[:error] = "Goodreads is currently down, please try your search again later."
      render :search
    end
  end

  def search_discussions
    @book_discussions = BookDiscussion.where("lower(book_title) LIKE ? AND status = 'public'", "%#{params[:q].downcase}%")
    if @book_discussions == []
      flash.now[:error] = "Sorry, we couldn\'t find any public book discussions for that search."
    end
  end

  def create
    @book_discussion = current_user.book_discussions.new(book_params)
    @book_discussion[:status] = 'private'
    if @book_discussion.save
      redirect_to @book_discussion
    else
      render :search
    end
  end

  def change_status
    if @book_discussion.status == 'private'
      @book_discussion[:status] = 'public'
    else
      @book_discussion[:status] = 'private'
    end
    @book_discussion.save
    redirect_to @book_discussion
  end

  def show
    redirect_to '/404' unless @book_discussion
  end

  def destroy
    User.find_each do |user|
      user.saved_discussions.delete(@book_discussion.id)
      user.save
    end
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
