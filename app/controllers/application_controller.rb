class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def initialize
    super

    url_helpers = Rails.application.routes.url_helpers

    @nav_links = [
      {
        text: 'browse',
        url: url_helpers.root_path
      },
      {
        text: 'creators',
        url: url_helpers.creators_path
      },
      {
        text: 'about',
        url: url_helpers.about_path
      },
      {
        text: 'search',
        url: url_helpers.search_path
      }
    ]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :username, :first_name, :last_name, :is_creator, :blurb])
  end

  def user_root_path
    Rails.application.routes.url_helpers.profile_path
  end
end
