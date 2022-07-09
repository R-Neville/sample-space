class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample

  def sample
    # Using 'find' here, because we
    # have the sample's ID - select * from
    # users where id = @sample.user_id:
    @creator = User.find(@sample.user_id)
  end

  def link
    # We can use the current user's
    # 'downloads' association to
    # find all downloads with a sample_id
    # equal to that of the @sample instance
    # variable, and if there are any (there
    # should only be one), we know that
    # the user has already downloaded
    # the sample - select * from downlaods
    # where user_id = current_user.id
    # and sample_id = @sample.id:
    @download = current_user.downloads.where(sample_id: @sample.id).first

    if !@download
      # The user has not already downloaded
      # the sample, so create a download
      # entry through the their 'downloads'
      # association with a sample ID equal
      # to that of the sample of the URL:
      current_user.downloads.create(sample_id: @sample.id)
      # Create a notification for the
      # download 'for' the creator of the
      # sample downloaded and 'from' the 
      # current user:
      Notification.create(
        for_id: @sample.user_id,
        from_id: current_user.id,
        sample_id: @sample.id,
        notification_type: 'download'
      )
    end

    # Send the sample to the user (direct download):
    send_data @sample.audio_file.download, disposition: 'attachment', filename: "#{@sample.name}.wav"
  end

  private

  def set_sample
    # Using 'find' here because we have
    # the sample's ID - select * from
    # samples where id = params[:id]:
    @sample = Sample.find(params[:id])
  end
end
