class ProfileController < ApplicationController
  before_action :authenticate_user!, :add_uploads_link
  before_action :redirect_if_not_creator, only: [:uploads]

  def initialize
    super

    url_helpers = Rails.application.routes.url_helpers

    @links = [
      {
        text: 'notifications',
        url: url_helpers.profile_path
      },
      {
        text: 'downloads',
        url: url_helpers.profile_downloads_path
      },
      {
        text: 'likes',
        url: url_helpers.profile_likes_path
      }
    ]
  end

  def index
    notifications = Notification.where(for_id: current_user.id)
    @notifications = []
    notifications.each do |n|
      from_user = User.find(n.from_id)
      sample = Sample.find(n.sample_id)
      @notifications.push(object: n, from_user: from_user, sample: sample)      
    end
  end

  def uploads
    samples = current_user.samples.all
    @samples_info = []
    samples.each do |sample|
      downloads = sample.downloads.all.count
      likes = sample.likes.all.count
      liked = sample.likes.where(user_id: current_user.id).length > 0
      @samples_info.push({sample: sample, likes: likes, liked: liked, downloads: downloads})
    end
  end

  def downloads
    downloads = current_user.downloads.all
    @samples_info = []
    downloads.each do |download|
      sample = Sample.where(id: download.sample_id).first
      likes = sample.likes.all.count
      liked = sample.likes.where(user_id: current_user.id).length > 0
      creator = User.where(id: sample.user_id).first
      download_count = sample.downloads.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes, liked: liked, downloads: download_count})
    end
  end

  def likes
    likes = current_user.likes.all
    @samples_info = []
    likes.each do |like|
      sample = Sample.where(id: like.sample_id).first
      creator = User.where(id: sample.user_id).first
      likes_count = Like.where(sample_id: sample.id).count
      download_count = sample.downloads.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes_count, downloads: download_count})
    end
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
