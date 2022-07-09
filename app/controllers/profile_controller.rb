class ProfileController < ApplicationController
  before_action :authenticate_user!, :add_uploads_link
  before_action :redirect_if_not_creator, only: [:uploads]

  def initialize
    super

    # @links contains the text and URLs for all
    # of the primary navigation links on the user's 
    # profile page. It is used in the profile layout to 
    # dynamically render the profile menu links so that
    # the link of the current page is highlighted
    # appropriately and there are no circular links
    # (see app/views/profile/shared/_nav.html.erb).

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
    # Here we are selecting * from notifications
    # where for_id = current_user.id (to get
    # all the notifications 'for' the current user):
    notifications = Notification.where(for_id: current_user.id)
    # Generate a list of hashes to be
    # used in rendering the notification
    # cards:
    @notifications = []
    notifications.each do |n|
      # We need some of the 'from' user's
      # info for the notification, so we
      # select * from users where id = n.from_id:
      from_user = User.find(n.from_id)
      # We need some of the sample's info
      # for the notification, so we select * from
      # samples where id = n.sample_id:
      sample = Sample.find(n.sample_id)
      @notifications.push(object: n, from_user: from_user, sample: sample)      
    end
  end

  def uploads
    # We need to show all the user's
    # uploaded samples so we select *
    # from samples where user_id = current_user.id:
    samples = current_user.samples.all
    # Generate a list of hashes
    # with all the necessary info
    # for each sample:
    @samples_info = []
    samples.each do |sample|
      # Select * from downloads where
      # sample_id = sample.id. Return
      # the count:
      downloads = sample.downloads.all.count
      # Select * from likes where sample_id = sample.id
      # and return the count:
      likes = sample.likes.all.count
      @samples_info.push({sample: sample, likes: likes, downloads: downloads})
    end
  end

  def downloads
    # We need to show all the samples that
    # the user has downloaded so select * from
    # downloads where user_id = current_user.id:
    downloads = current_user.downloads.all
    # Generate a list of hashes with all 
    # the necessary sample info:
    @samples_info = []
    downloads.each do |download|
      # Get the sample - select * from samples where
      # id = download.sample_id:
      sample = Sample.find(download.sample_id)
      # Select * from likes where sample_id = sample.id:
      likes = sample.likes.all.count
      # Get the creator (select * from users where id = sample.user_id):
      creator = User.find(sample.user_id)
      # Get the download count (select * from downloads where
      # sample_id = sample.id) and return the count:
      download_count = sample.downloads.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes, downloads: download_count})
    end
  end

  def likes
    # We need all the likes for the current user,
    # so select * from likes where user_id = current_user.id:
    likes = current_user.likes.all
    # Generate a list of hashes with all the necessary info:
    @samples_info = []
    likes.each do |like|
      # Select * from samples where id = like.sample_id:
      sample = Sample.find(like.sample_id)
      # Select from users where id = sample.user_id:
      creator = User.find(sample.user_id)
      # Select * from likes where sample_id = sample.id:
      likes_count = Like.where(sample_id: sample.id).count
      # Select * from downloads where sample_id = sample.id:
      download_count = sample.downloads.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes_count, downloads: download_count})
    end
  end

  protected

  def add_uploads_link
    if current_user.is_creator
      # Add the 'uploads' tab if the current
      # user is a creator:
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
