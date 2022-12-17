class NotesController < ApplicationController
  def index
    headings = current_user&.headings
    heading = headings&.find(params[:heading_id])
    notes = heading&.notes
    if notes
      render json: notes
    else
      render json: {
        status: 500,
        errors: ['no notes found for this heading']
      }
    end
  end

  def show
    note = Note.find(url_params[:id])
    heading = note.heading
    if note
      render json: {
        note:,
        heading:
      }
    else
      render json: {
        status: 500,
        errors: ["no note of id #{params[:id]} found this user"]
      }
    end
  end

  def create
    note = Note.new(note_params)
    if note.save
      render json: {
        status: :created,
        note:
      }
    else
      render json: {
        status: 500,
        errors: note.errors.full_messages
      }
    end
  end

  def update
    note = Note.find(note_params[:id])
    if note
      note.content = note_params[:content]
      if note.save
        render json: {
          status: :success
        }
      end
    else
      render json: {
        status: 500,
        errors: note.errors.full_messages
      }
    end
  end

  private

  def note_params
    params.require(:note).permit(:id, :content, :heading_id)
  end

  def url_params
    params.permit(:id)
  end
end
