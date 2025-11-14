# ./config/initializers/auth0.rb
AUTH0_CONFIG = Rails.application.config_for(:auth0)

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