class CreatorsController < ApplicationController
  def index
    @creators = User.where(is_creator: true)
  end

  def view
    @creator = User.where(username: params[:username]).first
    puts @creator
  end
end
