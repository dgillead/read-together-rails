class SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_discussion, only: [:new, :create, :destroy]
  before_action :find_section, only: [:show, :destroy, :edit, :update]

  def new
    @section = Section.new
  end

  def create
    @section = @book_discussion.sections.new(section_params)
    if @section.save
      redirect_to @section.book_discussion
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @book_discussion = @section.book_discussion
    @section.destroy
    redirect_to @book_discussion
  end

  def edit
  end

  def update
    if @section.update_attributes(section_params)
      redirect_to @section
    else
      render :edit
    end
  end

  private

  def find_discussion
    @book_discussion = BookDiscussion.find_by(id: params[:book_discussion_id])
  end

  def find_section
    @section = Section.find_by(id: params[:id])
  end

  def section_params
    params.require(:section).permit(:title)
  end
end
