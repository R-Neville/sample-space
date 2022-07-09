class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_sample
  before_action :set_comment, only: [:edit, :update, :destroy, :like, :unlike]

  def new
    # Initialise an instance variable
    # with an object of the Comment
    # model with a sample ID of the 
    # currently viewed sample.
    @comment = @sample.comments.new
  end

  def edit
  end

  def create
    # Add the current user's ID to the
    # comment hash to identify the commenter:
    params[:comment][:user_id] = current_user.id

    @comment = @sample.comments.create(comment_params)

    if @comment.save
      # Only create a notification if 
      # the current user is not the creator
      # of the sample:
      if @comment.user_id != @sample.user_id
        Notification.create(
          for_id: @sample.user_id,
          from_id: current_user.id,
          sample_id: @sample.id,
          notification_type: 'comment'
        )
      end
      redirect_to show_sample_path(@sample.id)
    else
      message = "Your comment can't be blank."
      redirect_to show_sample_path(@sample.id), alert: message
    end
  end

  def update
    if @comment.update(comment_params)
      # The comment was updated successfully,
      # return to the sample's page (the index
      # of all comments for that sample):
      redirect_to show_sample_path(@sample.id)
    else
      # The comment was not updated successfully.
      # Most likely this is because the user
      # left the comment content blank.
      # Redirect to the edit sample comment page
      # with an appropriate error message:
      message = "Your comment can't be blank."
      redirect_to edit_sample_comment_path(sample_id: @sample.id, comment_id: @comment.id), alert: message
    end
  end

  def destroy
    # Delete the comment and return to the
    # sample's page (the index for all comments
    # on the sample):
    @comment.destroy
    redirect_to show_sample_path(@sample.id)
  end

  def like
    # Can't use the find method here, because
    # we don't know if the user has already
    # liked the comment yet (and we don't have
    # an ID for the 'like') - select * from 
    # comment_likes where user_id = current_user.id:
    like = @comment.comment_likes.where(user_id: current_user.id).first
    if !like
      # The user has not already liked the comment.
      # Create a new like for the comment through
      # its 'comment_likes' association, and set 
      # the user ID to the current user:
      @comment.comment_likes.create(user_id: current_user.id)
      # Create a notification for the sample's
      # creator (from the current user - the user
      # that commented):
      Notification.create(
        for_id: @comment.user_id,
        from_id: current_user.id,
        sample_id: @sample.id,
        notification_type: 'comment-like'
      )
    end
    redirect_to show_sample_path(@sample.id)
  end

  def unlike
    # Can't use the find method here, because
    # we don't know if the user has already
    # liked the comment yet (and we don't have
    # an ID for the 'like'). So, we select * from
    # comment_likes where comment_id = @comment.id
    # and user_id = current_user.id:
    like = @comment.comment_likes.where(user_id: current_user.id).first
    if like
      # The user has liked the comment
      # at some point, so proceed to 
      # delete it:
      like.destroy
    end
    # We need to redirect to the sample's page
    # regardless of the outcome:
    redirect_to show_sample_path(@sample.id)
  end

  private

  def get_sample
    # Here we can use find because we 
    # have the sample's ID - select * from
    # samples where id = params[:sample_id]:
    @sample = Sample.find(params[:sample_id])
  end

  def set_comment
    # We have the ID of the comment
    # in params, so we can use 'find' - 
    # select * from comments where 
    # sample_id = @sample.id and 
    # id = params[:comment_id]:
    @comment = @sample.comments.find(params[:comment_id])
  end

  def comment_params
    params.require(:comment).permit(:sample_id, :user_id, :content)
  end
end
