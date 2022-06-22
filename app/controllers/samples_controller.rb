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
    params.require(:sample).permit(:name, :description, :length, :sample_rate, :bit_depth,
                                  :likes, :downloads, :price, :audio_file)
  end
end
