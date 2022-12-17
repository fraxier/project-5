class SessionsController < ApplicationController
  def login
    @user = User.find_by(email: session_params[:email])
    
    if @user&.authenticate(session_params[:password])
      login!
      render json: {
        logged_in: true,
        user: @user
      }
    else
      render json: {
        status: 401,
        errors: ['email/password combination not found, please try again.']
      }
    end
  end

  def is_logged_in?
    if logged_in? && current_user
      render json: {
        logged_in: true,
        user: current_user
      }
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end

  def mega_summary
    recent_learnings = Learning.recent_learnings(session[:user_id], 5)
    tags_summary = Tag.summary(session[:user_id])
    started_learning = current_user.created_at
    main_learnings = Tag.main_tag_learnings(session[:user_id])
    completed_learnings = Tag.completed_learnings(session[:user_id])

    total_learnings = current_user.learnings.count
    most_common_tags = Tag.most_common(session[:user_id])
    total_tags = current_user.tags.count
    total_completed = current_user.tags.find_by(name: 'Completed')&.learnings&.count || 0
    render json: {
      recent_learnings:,
      tags_summary:,
      started_learning:,
      main_learnings:,
      completed_learnings:,

      total_learnings:,
      most_common_tags:,
      total_tags:,
      total_completed:
    }
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
