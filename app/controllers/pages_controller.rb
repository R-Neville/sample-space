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
