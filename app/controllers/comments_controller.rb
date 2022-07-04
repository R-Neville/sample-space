class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_sample
  before_action :set_comment, only: [:edit, :update, :destroy, :like, :unlike]

  def new
    @comment = @sample.comments.new
  end

  def edit
  end

  def create
    params[:comment][:user_id] = current_user.id

    @comment = @sample.comments.create(comment_params)

    if @comment.save
      Notification.create(
        for_id: @sample.user_id,
        from_id: current_user.id,
        sample_id: @sample.id,
        notification_type: 'comment'
      )
      redirect_to show_sample_path(@sample.id)
    else
      message = "Your comment can't be blank."
      redirect_to show_sample_path(@sample.id), alert: message
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to show_sample_path(@sample.id)
    else
      message = "Your comment can't be blank."
      redirect_to edit_sample_comment_path(sample_id: @sample.id, comment_id: @comment.id), alert: message
    end
  end

  def destroy
    @comment.destroy
    redirect_to show_sample_path(@sample.id)
  end

  def like
    like = @comment.comment_likes.where(user_id: current_user.id).first
    if !like
      @comment.comment_likes.create(user_id: current_user.id)
      
      Notification.create(
        for_id: @sample.user_id,
        from_id: current_user.id,
        sample_id: @sample.id,
        notification_type: 'comment-like'
      )
    end
    redirect_to show_sample_path(@sample.id)
  end

  def unlike
    like = @comment.comment_likes.where(user_id: current_user.id).first
    if like
      like.destroy
    end
    redirect_to show_sample_path(@sample.id)
  end

  private

  def get_sample
    @sample = Sample.find(params[:sample_id])
  end

  def set_comment
    @comment = @sample.comments.find(params[:comment_id])
  end

  def comment_params
    params.require(:comment).permit(:sample_id, :user_id, :content)
  end
end
