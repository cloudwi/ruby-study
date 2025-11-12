class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Use the client's timezone (if provided via cookie) for the duration of each request.
  around_action :switch_time_zone

  private

  def switch_time_zone(&block)
    tz_name = cookies[:timezone]
    zone = tz_name.present? ? ActiveSupport::TimeZone[tz_name] : nil
    zone ||= Time.zone # fall back to app default

    if zone
      Time.use_zone(zone, &block)
    else
      yield
    end
  end
end
