class PagesController < ApplicationController
  def home
    @popular_tags = get_popular_tags
    # Get all samples where is_public = true 
    # and order them by the time they where created.
    # We only want the 10 most recent! - select *
    # from samples where is_public = true order by created_at
    # (only return the last 10):
    recent_uploads = Sample.where(is_public: true).order("created_at").last(10)
    # Create an array of hashes
    # with all required info for
    # rendering the sample cards:
    @recent_uploads_info = []
    recent_uploads.each do |upload|
      # Select * from likes. We only want
      # the count:
      likes = upload.likes.all.count
      # Select * from users where id = upload.user_id:
      creator = User.find(upload.user_id)
      # Select * from downloads where sample_id = upload.id.
      # We only want the count:
      download_count = upload.downloads.all.count
      @recent_uploads_info.push({
        sample: upload, 
        creator: creator, 
        likes: likes, 
        downloads: download_count
      })
    end
  end

  def about
  end

  def search
    @q = params[:q]

    if @q && @q != ''
      # Downcase so we can perform a case-insensitive search:
      @q = @q.downcase

      # Here we are performing a join (an inner join)! So, we select * from
      # samples where is_public = true join users on samples.user_id = users.id:
      samples = Sample.where(is_public: true).joins(:user)

      @results = {samples: [], creators: []}
      
      samples.each do |sample|
        if sample.name.downcase.include?(@q)
          # The sample's name includes the query,
          # add it to the samples results list:
          @results[:samples].push(sample)
        end

        # Select all tags of the sample that include the
        # query string:
        similar_tags = sample.tag_list.select { |tag| tag.downcase.include?(@q) }
        
        if similar_tags.length > 0
          # At least one similar tag was found,
          # so add the sample to the samples results
          # list:
          @results[:samples].push(sample)
        end

        if sample.user.username.downcase.include?(@q)
          # The username of the sample's corresponding user
          # (found in the join operation) includes the query
          # string, so add both the user (creator) and
          # the sample to the results lists:
          @results[:creators].push(sample.user)
          @results[:samples].push(sample)
        end
      end

      # Make sure there are no duplicates
      # in the results...
      @results[:samples].uniq!
      @results[:creators].uniq!
    end
  end

  private

  def get_popular_tags
    # First we get all public uploaded samples 
    # - select * from samples where is_public = true:
    @samples = Sample.where(is_public: true)
    tags_in_use = []
    @samples.each do |sample|
      # Add the concatenate the elements
      # from the sample's tag list into
      # the list of all tags in use:
      tags_in_use.concat(sample.tag_list)
    end
    # Get the 20 most used tags from ActsAsTaggableOn:
    most_used_tags = ActsAsTaggableOn::Tag.most_used(20)
    # Return the intersection of all tags in use
    # and the 20 most used tags (we are doing this
    # because tags that there are no current taggings
    # for, still show up in most used tags!):
    tags_in_use.uniq & most_used_tags.map { |t| t.name }
  end
end
