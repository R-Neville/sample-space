class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_sample
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @sample.comments.new
  end

  def edit
  end

  def create
    params[:comment][:user_id] = current_user.id

    @comment = @sample.comments.create(comment_params)

    if @comment.save
      redirect_to show_sample_path(@sample.id)
    else
      message = "Your comment can't be blank."
      redirect_to show_sample_path(@sample.id), alert: message
    end
  end

  def destroy
    @comment.destroy
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
