class ProfileController < ApplicationController
  before_action :authenticate_user!, :add_uploads_link
  before_action :redirect_if_not_creator, only: [:uploads]

  def initialize
    super

    url_helpers = Rails.application.routes.url_helpers

    @links = [
      {
        text: 'recent',
        url: url_helpers.profile_path
      },
      {
        text: 'downloads',
        url: url_helpers.profile_downloads_path
      },
      {
        text: 'likes',
        url: url_helpers.profile_likes_path
      },
      {
        text: 'wishlist',
        url: url_helpers.profile_wishlist_path
      }
    ]
  end

  def index
  end

  def uploads
    @samples = current_user.samples.all
  end

  def downloads
  end

  def likes
  end

  def wishlist
  end

  protected

  def add_uploads_link
    if current_user.is_creator
      @links.insert(1, {
        text: 'uploads',
        url: Rails.application.routes.url_helpers.profile_uploads_path
      })
    end
  end

  def redirect_if_not_creator
    message = 'You need to switch to creator mode to upload samples.'
    redirect_to profile_path, alert: message unless current_user.is_creator
  end
end
