class TagsController < ApplicationController
  def index
    tags = current_user.tags
    if tags
      render json: tags
    else
      render json: {
        status: 500,
        errors: ["couldn't find tags for this user"]
      }
    end
  end

  def show; end

  def create
    tag = Tag.new(tag_params)
    tag&.user_id = current_user.id
    if tag.save
      render json: {
        status: :created,
        tag:
      }
    else
      render json: {
        status: 500,
        errors: tag.errors.full_messages
      }
    end
  end

  def destroy
    tag = Tag.find(url_params[:id])
    if tag.user_id == session[:user_id] && tag.destroy
      return render json: {
        status: :delete,
        tag: { id: url_params[:id], name: tag.name }
      }
    end
    render json: {
      status: 500,
      errors: tag.errors.full_messages
    }
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :bg_color, :font_color)
  end

  def url_params
    params.permit(:id)
  end
end
