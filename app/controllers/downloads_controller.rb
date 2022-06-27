class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample

  def sample
  end

  def link
    @download = current_user.downloads.where(sample_id: @sample.id).first

    if !@download
      current_user.downloads.create(sample_id: @sample.id)
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
