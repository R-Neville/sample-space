class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    Notification.find(params[:id]).destroy
    redirect_to profile_path
  end
end
