class CreatorsController < ApplicationController
  def index
    @creators = User.where(is_creator: true)
  end

  def show
    @creator = User.where(username: params[:username]).first
    @samples = @creator.samples.where(is_public: true)
  end
end
