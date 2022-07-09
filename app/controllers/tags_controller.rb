class TagsController < ApplicationController
  def show
    # Get all the samples that are tagged
    # with params[:tag] - something like
    # select * from taggings where taggable_type
    # = Sample innher join samples on taggings.taggable_id = samples.id...
    @samples = Sample.tagged_with(params[:tag])
    # Filter out all non-public samples:
    samples = @samples.select { |sample| sample.is_public }
    # Generate a list of hashes containing
    # necessary info for rendering the sample cards:
    @samples_info = []
    samples.each do |sample|
      # Select * from users where id = sample.user_id:
      creator = User.find(sample.user_id)
      # Select * from downloads where sample_id = sample.id:
      downloads = sample.downloads.all.count
      # Select * from likes where sample_id = sample.id:
      likes = sample.likes.all.count
      @samples_info.push({sample: sample, creator: creator, likes: likes, downloads: downloads})
    end
    @tag = params[:tag]
  end
end
