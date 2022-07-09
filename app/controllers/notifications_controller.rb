class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    # Get the notification by its ID -
    # select * from notifications where
    # id = params[:id] - and delete it!
    Notification.find(params[:id]).destroy
    redirect_to profile_path
  end
end
