class CreatorsController < ApplicationController
  def index
    @creators = User.where(is_creator: true)
  end

  def show
    @creator = User.where(username: params[:username]).first
    samples = @creator.samples.where(is_public: true)
    @samples_info = []
    samples.each do |sample|
      downloads = sample.downloads.all.count
      @samples_info.push({sample: sample, downloads: downloads})
    end
  end
end
