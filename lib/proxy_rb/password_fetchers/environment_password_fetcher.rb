# frozen_string_literal: true
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

      # Prefix of key in Environment
      def initialize(prefix:)
        @prefix = prefix
      end

      # @param [String] user_name
      #   Look up user name
      Contract String => String
      def call(user_name)
        UserPasswords::EnvironmentUserPassword.new(
          fetch_password_for_user(user_name)
        ).to_s
      end

      private

      def read(string)
        ENV[format('%s_%s', prefix, string)]
      end
    end
  end
end
