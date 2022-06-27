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
      likes = sample.likes.all.count
      if current_user
        liked = sample.likes.where(user_id: current_user.id).length > 0
      end
      @samples_info.push({sample: sample, likes: likes, liked: liked, downloads: downloads})
    end
  end
end
