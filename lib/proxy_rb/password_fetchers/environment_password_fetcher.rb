require 'proxy_rb/password_fetchers/basic_password_fetcher'
require 'proxy_rb/user_passwords/environment_user_password'

module ProxyRb
  # Fetch password for user...
  module PasswordFetchers
    # ... process environment
    class EnvironmentPasswordFetcher < BasicPasswordFetcher
      include Contracts::Core
      include Contracts::Builtin

      protected

      attr_reader :prefix

      public

      def initialize(prefix:)
        @prefix = prefix
      end

      Contract String => String
      def call(user_name)
        UserPasswords::EnvironmentUserPassword.new(
          ENV[format('%s_%s', prefix, user_name.upcase)]
        ).to_s
      end
    end
  end
end
