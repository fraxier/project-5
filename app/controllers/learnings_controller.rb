require 'pry'
class LearningsController < ApplicationController
  def index
    learnings = current_user.learnings&.order(updated_at: :desc)
    learnings = learnings&.map do |learning|
      { learning:, tags: learning.tags }
    end
    if learnings
      render json: learnings
    else
      render json: {
        status: 500,
        errors: ['no learnings found for this user']
      }
    end
  end

  def show
    learning = current_user.find_learning(params[:id])
    if learning
      result = {
        learning:,
        tags: learning.tags,
        headings: learning.headings.map do |head|
          { heading: head, notes: head.notes }
        end
      }
      render json: result
    else
      render json: {
        status: 500,
        errors: ['learning not found for this user']
      }
    end
  end

  def create
    learning = Learning.new(learning_params)
    learning.user_id = current_user.id
    tags = params[:tags]
    tags.each do |tag|
      learning.tags << Tag.find(tag[:id])
    end
    if learning.save
      render json: {
        status: :created,
        learning:
      }
    else
      render json: {
        status: 500,
        errors: learning.errors.full_messages
      }
    end
  rescue StandardError => e
    render json: {
      status: 500,
      errors: e
    }
  end

  def update
    if learning_params[:updated_at] == true
      learning = Learning.find(learning_params[:id])
      if learning
        learning[:updated_at] = DateTime.now
        learning.save
        render json: { results: 'Updated successfully' }
      end
    end
  rescue StandardError => e
    render json: {
      status: 500,
      errors: e
    }
  end

  def remove_tag
    learning = Learning.find(tag_params[:learning_id])
    tag = Tag.find(tag_params[:tag_id])
    if learning && tag
      learning.tags.delete tag
      if learning.save
        return render json: {
          status: :deleted,
          tag:
        }
      end
    end
    render json: {
      status: 500,
      errors: ['Something went wrong trying to remove tag from learning']
    }
  end

  def add_tags
    learning = Learning.find(params[:learning_id])
    if learning
      learning.tags << tags = params[:tags].map do |tag|
        Tag.find(tag[:id])
      end
      if learning.save
        render json: {
          tags:
        }
      end
    end
  rescue StandardError => e
    render json: {
      status: 500,
      errors: e
    }
  end

  def recent
    params.permit(:num)
    num = params[:num]
    num ||= 5
    render json: {
      results: Learning.recent_learnings(session[:user_id], num)
    }
  end

  def main_learnings
    render json: {
      results: Tag.main_tag_learnings(session[:user_id], 5)
    }
  end

  def count_learnings_by_tag
    render json: {
      results: Tag.count_learnings_by_tag(session[:user_id])
    }
  end

  private

  def learning_params
    params.require(:learning).permit(:id, :name, :motivation, :updated_at, :tags)
  end

  def tag_params
    params.permit(:learning_id, :tag_id)
  end
end
