class TagsController < ApplicationController
  def index
  end

  def show
    @samples = Sample.tagged_with(params[:tag])
    if @samples.length > 0
      @samples = @samples.select { |sample| sample.is_public }
      @tag = params[:tag]
    end
  end
end
