# frozen_string_literal: true
require 'contracts'

# ProxyRb
module ProxyRb
  # Helpers
  module Api
    # Helpers to access passwords
    module Passwords
      include Contracts::Core
      include Contracts::Builtin

      Contract Or[String, Symbol] => Maybe[String]
      # Get password for user
      #
      # @param [String] user_name
      #   The user name
      #
      # @return [String]
      #   The password
      def password(user_name)
        ProxyRb.config.password_fetcher.call(user_name.to_s)
      end
    end
  end
end
