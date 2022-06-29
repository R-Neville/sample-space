require 'wavefile'
include WaveFile

class SamplesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_sample, only: [:edit, :update, :show, :destroy, :download]

  def show
    @creator = User.find(@sample.user_id)
    @downloads = @sample.downloads.all.count
    @likes = @sample.likes.all.count
    if current_user
      @liked = @sample.likes.where(user_id: current_user.id).length > 0
      @downloaded = @sample.downloads.where(user_id: current_user.id).length > 0
    end
  end

  def new
    @sample = Sample.new
  end

  def edit
  end

  def create
    if params[:sample][:audio_file]
      add_metadata_to_params
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
    @sample.destroy
    redirect_to profile_uploads_path, status: :see_other
  end

  private

  def set_sample
    @sample = Sample.find(params[:id])
  end

  def sample_params
    params.require(:sample).permit(:name, :description, :duration, :sample_rate, :bit_depth,
                                  :likes, :downloads, :price, :audio_file, :is_public, :tag_list)
  end

  def add_metadata_to_params
    reader = Reader.new(params[:sample][:audio_file].tempfile)
    ms_str = reader.total_duration.milliseconds.to_s
    s_str = reader.total_duration.seconds.to_s
    m_str = reader.total_duration.minutes.to_s
    h_str = reader.total_duration.hours.to_s

    duration = "#{h_str}:#{m_str}:#{s_str}.#{ms_str}"
    
    params[:sample][:duration] = duration
    params[:sample][:bit_depth] = reader.native_format.bits_per_sample
    params[:sample][:sample_rate] = reader.native_format.sample_rate
    params[:sample][:price] = 0
    params[:sample][:audio_file].original_filename = "#{params[:sample][:name]}.wav"
  end
end
