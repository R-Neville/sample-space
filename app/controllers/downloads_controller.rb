class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample

  def sample
  end

  def link
    @download = current_user.downloads.where(sample_id: @sample.id).first

    if !@download
      current_user.downloads.create(sample_id: @sample.id)
      for_user = User.find(@sample.user_id)
      Notification.create(
        for_id: for_user.id,
        from_id: current_user.id,
        sample_id: @sample.id,
        notification_type: 'download'
      )
    end

    send_data @sample.audio_file.download, disposition: 'attachment', filename: "#{@sample.name}.wav"
  end

  private

  def create

  end

  def set_sample
    @sample = Sample.find(params[:id])
  end
end
