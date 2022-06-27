class TagsController < ApplicationController
  def index
  end

  def show
    @samples = Sample.tagged_with(params[:tag])
    if @samples.length > 0
      samples = @samples.select { |sample| sample.is_public }
      @samples_info = []
      samples.each do |sample|
        downloads = sample.downloads.all.count
        @samples_info.push({sample: sample, downloads: downloads})
      end
      @tag = params[:tag]
    end
  end
end
