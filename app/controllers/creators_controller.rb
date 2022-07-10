class CreatorsController < ApplicationController
  def index
    @creators = User.where(is_creator: true)
  end

  def show
    # Can't use 'find' here because
    # we need to select the creator by
    # their username - select * from 
    # users where username = params[:username]:
    @creator = User.where(username: params[:username]).first
    # We can use the creator object's 'samples'
    # association to find all those samples
    # uploaded by that creator, which are public
    # - select * from samples where creator_id = 
    # @creator.id and is_public = true:
    samples = @creator.samples.where(is_public: true)
    
    @tags = []
    # Here, we are gathering a list
    # of all the tags for all the 
    # creator's public samples:
    samples.each do |sample|
      @tags.concat sample.tag_list
    end
    @tags.uniq! # Make sure there are no duplicates.

    # Create sample info hash for each sample:
    @samples_info = []
    samples.each do |sample|
      # Here we can use the sample's
      # 'downloads' association to 
      # select all download records
      # with a sample ID that is equal
      # to the ID of 'sample' - select *
      # from downloads where sample_id
      # = sample.id:
      downloads = sample.downloads.all.count
      # Similarly, we can use the
      # sample's 'likes' association
      # to select all like records
      # with a sample ID that is equal
      # to the ID of 'sample' - select *
      # from likes where sample_id = sample.id:
      likes = sample.likes.all.count
      if current_user
        # The user is authenticated,
        # so check if they have liked the
        # the sample. Using 'where' here
        # becuase we don't have the like
        # ID - select * from likes where
        # sample_id = sample.id and 
        # user_id = current_user.id:
        liked = sample.likes.where(user_id: current_user.id).length > 0
      end
      @samples_info.push({sample: sample, likes: likes, liked: liked, downloads: downloads})
    end
  end
end
