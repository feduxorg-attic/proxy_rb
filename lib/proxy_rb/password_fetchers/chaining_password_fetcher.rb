# frozen_string_literal: true
require 'proxy_rb/password_fetchers/basic_password_fetcher'

module ProxyRb
  # Fetch password for user...
  module PasswordFetchers
    # ... process environment
    class ChainingPasswordFetcher < BasicPasswordFetcher
      include Contracts::Core
      include Contracts::Builtin

      protected

      attr_reader :fetchers

      public

      # Prefix of key in Environment
      def initialize(fetchers)
        @fetchers = Array(fetchers)
      end

      # @param [String] user_name
      #   Look up user name
      Contract String => String
      def call(user_name)
        fetch_password_for_user(user_name)
      end

      private

      def fetch_password_for_user(user_name)
        result = nil

        fetchers.each do |f|
          begin
            result = f.call(user_name)
          rescue ArgumentError
            result = nil
          end

          break unless result.nil?
        end

        raise ArgumentError, %(Failed to fetch password for username "#{user_name}") if result.nil?

        result
      end

      # Not needed for this fetcher
      def read(_string); end
    end
  end
end
