class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def initialize
    super

    @nav_links = [
      {
        text: 'browse',
        url: Rails.application.routes.url_helpers.browse_path
      },
      {
        text: 'creators',
        url: Rails.application.routes.url_helpers.creators_path
      },
      {
        text: 'about',
        url: Rails.application.routes.url_helpers.about_path
      },
      {
        text: 'contact',
        url: Rails.application.routes.url_helpers.contact_path
      }
    ]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
  end
end
