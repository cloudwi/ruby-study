# ./config/initializers/auth0.rb

# Load Auth0 configuration if available
begin
  AUTH0_CONFIG = Rails.application.config_for(:auth0)
rescue RuntimeError
  # Config file not found or environment variables not set
  AUTH0_CONFIG = nil
end

# Monkey patch to disable SSL verification in development environment only
if Rails.env.development?
  require 'net/http'

  module Net
    class HTTP
      alias_method :original_use_ssl=, :use_ssl=

      def use_ssl=(flag)
        self.original_use_ssl = flag
        if flag
          self.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end

# Only configure OmniAuth if Auth0 config is available
if AUTH0_CONFIG.present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :auth0,
      AUTH0_CONFIG['auth0_client_id'],
      AUTH0_CONFIG['auth0_client_secret'],
      AUTH0_CONFIG['auth0_domain'],
      callback_path: '/auth/auth0/callback',
      authorize_params: {
        scope: 'openid profile email'
      }
    )
  end
else
  Rails.logger.warn "Auth0 configuration not found - authentication disabled"
end