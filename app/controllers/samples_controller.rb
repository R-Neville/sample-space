require 'wavefile'
include WaveFile

class SamplesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_sample, only: [:edit, :update, :show, :destroy]

  def show
    # We can use find here because we have the
    # creator's id - select * from users where
    # id = @sample.user_id:
    @creator = User.find(@sample.user_id)
    # Get all downloads - select * from
    # downloads where sample_id = @sample.id -
    # and return just the count:
    @downloads = @sample.downloads.all.count
    # Get all the likes - select * from 
    # likes where sample_id = @sample.id - 
    # and return just the count:
    @likes = @sample.likes.all.count
    if current_user
      # The user is authenticated!
      
      # Get the user's 'liked' status - 
      # select * from likes where user_id = current_user.id:
      @liked = @sample.likes.where(user_id: current_user.id).length > 0
      # Get the user's 'downloaded' status -
      # select * from downloads where user_id = current_user.id:
      @downloaded = @sample.downloads.where(user_id: current_user.id).length > 0
    end

    # Create a new comment for the form rendering:
    @comment = @sample.comments.new
    # Get all comments - select * from comments
    # where sample_id = @sample.id and order by
    # created_id:
    comments = @sample.comments.order(created_at: :asc)
    # Generate a list of hashes to store
    # necessary info for each comment:
    @comments_info = []
    comments.each do |comment|
      # Get the comment's user - 
      # select * from users where
      # id = comment.user_id:
      user = User.find(comment.user_id)
      # Get all the likes for the comment
      # - select * from comment_likes where
      # comment_id = comment.id:
      likes = comment.comment_likes.all
      if current_user
        # Check to see if the user has liked
        # the sample:
        liked = likes.select { |like| like.user_id == current_user.id }.length > 0
      end
      @comments_info.push({comment: comment, user: user, likes: likes.length, liked: liked })
    end
  end

  def new
    # Creating a new sample object but
    # not saving to the database yet.
    # Just for form rendering:
    @sample = Sample.new
  end

  def edit
  end

  def create
    if params[:sample][:audio_file]
      # The user has attached an audio
      # file, so get its metadata:
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
    # Update the sample with the
    # data received from the form's
    # submission:
    if @sample.update(sample_params)
      redirect_to profile_uploads_path
    else
      # One or more form fields contained invalid
      # data:
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Delete the sample:
    @sample.destroy
    redirect_to profile_uploads_path, status: :see_other
  end

  private

  def set_sample
    # We can use 'find' here because we
    # have the sample's ID - select *
    # from samples where id = params[:id]:
    @sample = Sample.find(params[:id])
  end

  def sample_params
    params.require(:sample).permit(:name, :description, :duration, :sample_rate, :bit_depth,
                                  :likes, :downloads, :price, :audio_file, :is_public, :tag_list)
  end

  def add_metadata_to_params
    # Here we are getting all the required 
    # metadata from the audio file:
    reader = Reader.new(params[:sample][:audio_file].tempfile)
    ms_str = reader.total_duration.milliseconds.to_s
    s_str = reader.total_duration.seconds.to_s
    m_str = reader.total_duration.minutes.to_s
    h_str = reader.total_duration.hours.to_s
    # Compile time values into the format used
    # by the application (00:00:00.000):
    duration = "#{h_str}:#{m_str}:#{s_str}.#{ms_str}"
    # Add the derived metadata to params:
    params[:sample][:duration] = duration
    params[:sample][:bit_depth] = reader.native_format.bits_per_sample
    params[:sample][:sample_rate] = reader.native_format.sample_rate
    params[:sample][:price] = 0
    params[:sample][:audio_file].original_filename = "#{params[:sample][:name]}.wav"
  end
end
