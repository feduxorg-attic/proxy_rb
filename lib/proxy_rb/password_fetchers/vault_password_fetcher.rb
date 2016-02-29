require 'proxy_rb/password_fetchers/basic_password_fetcher'
require 'proxy_rb/user_passwords/vault_user_password'

begin
  require 'vault'
rescue LoadError
  ProxyRb.logger.error 'Please add `vault` to your `Gemfile` to use this password fetcher'
end

module ProxyRb
  # Fetch password for user...
  module PasswordFetchers
    # ... from HashiCorp Vault
    class VaultPasswordFetcher < BasicPasswordFetcher
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
        ::Vault.with_retries(::Vault::HTTPConnectionError, ::Vault::HTTPError) do |attempt, e|
          UserPasswords::VaultUserPassword.new(
            ::Vault.logical.read(File.join(prefix, user_name))
          ).to_s
        end
      end
    end
  end
end
