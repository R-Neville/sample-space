class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = Like.where(sample_id: params[:sample_id], user_id: current_user.id).first
    if !like
      Like.create(sample_id: params[:sample_id], user_id: current_user.id)
      
      sample = Sample.find(params[:sample_id])
      for_user = User.find(sample.user_id)
      
      Notification.create(
        for: for_user,
        from: current_user,
        sample_id: sample.id,
        notification_type: 'like'
      )
    end
    redirect_to show_sample_path(params[:sample_id])
  end

  def destroy
    like = Like.where(sample_id: params[:sample_id], user_id: current_user.id).first
    if like
      like.destroy
    end
    redirect_to show_sample_path(params[:sample_id])
  end
end
