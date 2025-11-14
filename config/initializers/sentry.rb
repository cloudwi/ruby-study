# Only enable Sentry in production to avoid SSL certificate issues in development
if Rails.env.production?
  Sentry.init do |config|
    config.dsn = 'https://24752814bd022ec107393b16ed310ff5@o4510362292781056.ingest.us.sentry.io/4510362308509696'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
end