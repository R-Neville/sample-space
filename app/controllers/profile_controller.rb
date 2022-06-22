class ProfileController < ApplicationController
  before_action :authenticate_user!

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

  def downloads
  end

  def likes
  end

  def wishlist
  end
end
