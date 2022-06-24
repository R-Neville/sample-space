class TagsController < ApplicationController
  def index
  end

  def show
    @samples = Sample.tagged_with(params[:tag])
    if @samples.length > 0
      @tag = params[:tag]
    end
  end
end
