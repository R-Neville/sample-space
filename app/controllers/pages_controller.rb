class PagesController < ApplicationController
  def home
  end

  def browse
    @popular_tags = ActsAsTaggableOn::Tag.most_used(20)
    recent_uploads = Sample.where(is_public: true).order("created_at").last(10)
    @recent_uploads_info = []
    recent_uploads.each do |upload|
      likes = upload.likes.all.count
      creator = User.where(id: upload.user_id).first
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

  def contact
  end
end
