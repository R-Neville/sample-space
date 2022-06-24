class DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample

  def sample
  end

  def link
    send_data @sample.audio_file.download, disposition: 'attachment', filename: "#{@sample.name}.wav"
  end

  private

  def set_sample
    @sample = Sample.find(params[:id])
  end
end
