class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Can't use 'find' here
    # because we don't have the
    # like's ID. So, we select *
    # from likes where sample_id
    # = params[:sample_id] and
    # user_id = current_user.id:
    like = Like.where(sample_id: params[:sample_id], user_id: current_user.id).first
    if !like
      # The user has not already liked the sample.
      # So, we create a new entry with sample_id = params[:sample_id]
      # and user_id = current_user.id:
      Like.create(sample_id: params[:sample_id], user_id: current_user.id)
      
      # Find the sample (select from samples
      # where id = params[:sample_id]) so 
      # we can also get the creator's id - 
      # select * from samples where id = params[:sample_id]:
      sample = Sample.find(params[:sample_id])

      Notification.create(
        for_id: sample.user_id,
        from_id: current_user.id,
        sample_id: sample.id,
        notification_type: 'like'
      )
    end
    redirect_to show_sample_path(params[:sample_id])
  end

  def destroy
    # Can't use 'find' here becuase we don't have the like's
    # ID. So, select * from likes where sample_id = params[:sample_id]
    # and user_id = current_user.id:
    like = Like.where(sample_id: params[:sample_id], user_id: current_user.id).first
    if like
      # The user does already like the sample,
      # so delete it (because that's what they want!):
      like.destroy
    end
    redirect_to show_sample_path(params[:sample_id])
  end
end
