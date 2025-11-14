Sentry.init do |config|
  config.dsn = 'https://24752814bd022ec107393b16ed310ff5@o4510362292781056.ingest.us.sentry.io/4510362308509696'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true

  # Set environment
  config.environment = Rails.env

  # In development, send fewer events to avoid noise
  if Rails.env.development?
    config.sample_rate = 0.5 # 50% of events
    config.traces_sample_rate = 0.25 # 25% of traces
  end
end