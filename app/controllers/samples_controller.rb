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
    filename = params[:audio_file].tempfile

    audio_metadata = get_audio_metadata(filename)

    params[:duration] = audio_metadata[:duration]
    params[:bit_depth] = audio_metadata[:bit_depth]
    params[:sample_rate] = audio_metadata[:sample_rate]
    params[:likes] = 0
    params[:downloads] = 0
    params[:price] = 0

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

  def get_audio_metadata(filename)
    reader = Reader.new(filename)
    bit_depth = reader.native_format.bits_per_sample
    sample_rate = reader.native_format.sample_rate
    duration = reader.total_duration.milliseconds
    { bit_depth: bit_depth, sample_rate: sample_rate, duration: duration }
  end
end
