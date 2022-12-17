class HeadingsController < ApplicationController
  def index
    headings = current_user&.headings
    if headings
      render json: {
        headings:
      }
    else
      render json: {
        status: 500,
        errors: ['no headings found for this subject']
      }
    end
  end

  def show
    headings = current_user&.headings
    heading = headings&.find(url_params[:id])
    notes = heading.notes
    if heading
      render json: {
        heading:,
        notes:
      }
    else
      render json: {
        status: 500,
        errors: ["no heading of id #{heading_params[:id]} found"]
      }
    end
  end

  def create
    heading = Heading.new(heading_params)
    if heading.save
      render json: {
        status: :created,
        heading:
      }
    else
      render json: {
        status: 500,
        errors: heading.errors.full_messages
      }
    end
  end

  private

  def heading_params
    params.require(:heading).permit(:name, :description, :learning_id)
  end

  def url_params
    params.permit(:learning_id, :id)
  end
end
