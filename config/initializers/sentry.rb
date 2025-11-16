# Sentry configuration
# In development, Sentry is disabled due to SSL certificate issues
# Set SENTRY_DSN environment variable in production

if Rails.env.production? || ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN'] || 'https://f573ec547d71c09defb67758c7931bec@o4510362292781056.ingest.us.sentry.io/4510377298493440'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.send_default_pii = true
    config.environment = Rails.env
    config.sample_rate = 1.0
    config.traces_sample_rate = 1.0
  end

  puts "✓ Sentry enabled for #{Rails.env} environment"
else
  puts "✗ Sentry disabled in #{Rails.env} (SSL certificate issues)"
  puts "  To enable: export SENTRY_DSN='your-dsn-here'"
end
