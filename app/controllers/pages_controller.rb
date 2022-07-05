class PagesController < ApplicationController
  def home
    @popular_tags = get_popular_tags
    recent_uploads = Sample.where(is_public: true).order("created_at").last(10)
    @recent_uploads_info = []
    recent_uploads.each do |upload|
      likes = upload.likes.all.count
      creator = User.find(upload.user_id)
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
      @q = @q.downcase

      samples = Sample.where(is_public: true).joins(:user)

      @results = {samples: [], creators: []}
  
      samples.each do |sample|
        if sample.name.downcase.include?(@q)
          @results[:samples].push(sample)
        end

        similar_tags = sample.tag_list.select { |tag| tag.downcase.include?(@q) }
        
        if similar_tags.length > 0
          @results[:samples].push(sample)
        end

        if sample.user.username.downcase.include?(@q)
          @results[:creators].push(sample.user)
          @results[:samples].push(sample)
        end
      end

      @results[:samples].uniq!
      @results[:creators].uniq!
    end
  end

  private

  def get_popular_tags
    @samples = Sample.all
    tags_in_use = []
    @samples.each do |sample|
      tags_in_use.concat(sample.tag_list)
    end
    most_used_tags = ActsAsTaggableOn::Tag.most_used(20)
    tags_in_use.uniq & most_used_tags.map { |t| t.name }
  end
end
