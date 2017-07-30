class SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_discussion, only: [:new, :create]
  before_action :find_section, only: [:show]

  def new
    @section = Section.new
  end

  def create
    @section = @book_discussion.sections.new(section_params)
    if @section.save
      redirect_to @section
    else
      render :new
    end
  end

  def show
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
