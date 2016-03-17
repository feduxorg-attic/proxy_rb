# frozen_string_literal: true
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

      attr_reader :prefix, :client

      public

      # @param [String] prefix
      #   Prefix used to look up password for user name
      #
      # @param [Vault::Client] client
      #   The client used to connect to central "Vault" server
      def initialize(prefix:, client: ::Vault::Client.new(address: ENV['VAULT_ADDR']))
        @prefix = prefix
        @client = client
      end

      # @param [String] user_name
      #   Look up user name
      Contract String => String
      def call(user_name)
        client.with_retries(::Vault::HTTPConnectionError, ::Vault::HTTPError) do |_attempt, _e|
          UserPasswords::VaultUserPassword.new(
            fetch_password_for_user(user_name)
          ).to_s
        end
      end

      private

      def read(string)
        ::Vault.logical.read(File.join(prefix, string))
      end
    end
  end
end
