class CreatorsController < ApplicationController
  def index
    @creators = User.where(is_creator: true)
  end

  def show
    @creator = User.where(username: params[:username]).first
    samples = @creator.samples.where(is_public: true)
    
    # Get all tags used by the creator:
    @tags = []
    samples.each do |sample|
      @tags.concat sample.tag_list
    end
    @tags.uniq!

    # Create sample info hash for each sample:
    @samples_info = []
    samples.each do |sample|
      downloads = sample.downloads.all.count
      likes = sample.likes.all.count
      if current_user
        liked = sample.likes.where(user_id: current_user.id).length > 0
      end
      @samples_info.push({sample: sample, likes: likes, liked: liked, downloads: downloads})
    end
  end
end
