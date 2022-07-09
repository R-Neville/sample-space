class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def initialize
    super

    url_helpers = Rails.application.routes.url_helpers

    # @nav_links contains the text and URLs for all
    # of the primary navigation links in the application.
    # It is used in the application layout to dynamically
    # render header, menu, and footer links so that
    # the link of the current page is highlighted
    # appropriately and there are no circular links
    # (see app/views/shared/_nav.html.erb).

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
    # Ensure that custom User fields are
    # expected and processed by devise when
    # users are registering or editing their
    # account:
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :username, :first_name, :last_name, :is_creator, :blurb])
  end

  def user_root_path
    # Redirect the user to their profile for
    # after all authentication related actions
    # (except for logging out):
    Rails.application.routes.url_helpers.profile_path
  end
end
