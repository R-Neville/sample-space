class ApplicationController < ActionController::Base
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
end
