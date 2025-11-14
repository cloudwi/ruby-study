# Disable SSL verification in development to avoid certificate issues
if Rails.env.development?
  require 'net/http'

  module Net
    class HTTP
      alias_method :original_use_ssl=, :use_ssl= unless method_defined?(:original_use_ssl=)

      def use_ssl=(flag)
        self.original_use_ssl = flag
        if flag
          self.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end

Sentry.init do |config|
  config.dsn = 'https://24752814bd022ec107393b16ed310ff5@o4510362292781056.ingest.us.sentry.io/4510362308509696'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true

  # Set environment
  config.environment = Rails.env

  # In development, send all events for testing
  if Rails.env.development?
    config.sample_rate = 1.0 # 100% of events
    config.traces_sample_rate = 1.0 # 100% of traces
  end
end