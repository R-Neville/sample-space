require 'wavefile'
include WaveFile

class SamplesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample, only: [:edit, :update, :show, :destory]

  def show
  end

  def new
    @sample = Sample.new
  end

  def edit
  end

  def create
    if params[:audio_file]
      add_metadata_to_params(params[:audio_file].tempfile)
    end
    
    @sample = current_user.samples.create(sample_params)

    if @sample.save
      redirect_to profile_uploads_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sample.update(sample_params)
      redirect_to profile_uploads_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sample.destory
    redirect_to profile_uploads_path, status: :see_other
  end

  private

  def set_sample
    @sample = Sample.find(params[:id])
  end

  def sample_params
    params.permit(:name, :description, :duration, :sample_rate, :bit_depth,
                                  :likes, :downloads, :price, :audio_file)
  end

  def add_metadata_to_params(filename)
    reader = Reader.new(filename)
    ms_str = reader.total_duration.milliseconds.to_s
    s_str = reader.total_duration.seconds.to_s
    m_str = reader.total_duration.minutes.to_s
    h_str = reader.total_duration.hours.to_s
    duration = "#{h_str}:#{m_str}:#{s_str}.#{ms_str}"
    params[:duration] = duration
    params[:bit_depth] = reader.native_format.bits_per_sample
    params[:sample_rate] = reader.native_format.sample_rate
    params[:likes] = 0
    params[:downloads] = 0
    params[:price] = 0
  end
end
