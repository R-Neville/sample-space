class TagsController < ApplicationController
  def index
  end

  def show
    @samples = Sample.tagged_with(params[:tag])
    samples = @samples.select { |sample| sample.is_public }
    @samples_info = []
    samples.each do |sample|
      creator = User.where(id: sample.user_id).first
      downloads = sample.downloads.all.count
      likes = sample.likes.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes, downloads: downloads})
    end
    @tag = params[:tag]
  end
end
