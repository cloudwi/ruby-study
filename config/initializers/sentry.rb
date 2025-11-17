# Sentry configuration
# In development, SSL verification is disabled to avoid certificate issues

if Rails.env.production? || ENV["SENTRY_DSN"].present?
  # Disable SSL verification in development to avoid certificate issues
  if Rails.env.development?
    require "net/http"

    # Monkey patch Net::HTTP to disable SSL verification
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
    config.dsn = ENV["SENTRY_DSN"] || "https://f573ec547d71c09defb67758c7931bec@o4510362292781056.ingest.us.sentry.io/4510377298493440"
    config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
    config.send_default_pii = true
    config.environment = Rails.env
    config.sample_rate = 1.0
    config.traces_sample_rate = 1.0

    # Additional transport configuration for development
    if Rails.env.development?
      config.transport.ssl_verification = false
    end
  end

  puts "✓ Sentry enabled for #{Rails.env} environment"
else
  puts "✗ Sentry disabled in #{Rails.env}"
  puts "  To enable: export SENTRY_DSN='your-dsn-here'"
end
