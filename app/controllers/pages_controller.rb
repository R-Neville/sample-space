class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def home
  end

  def browse
  end

  def creators
  end

  def about
  end

  def contact
  end

  def profile
  end
end
