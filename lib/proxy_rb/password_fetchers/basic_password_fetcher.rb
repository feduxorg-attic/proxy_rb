# frozen_string_literal: true
module ProxyRb
  # Fetch password for user...
  module PasswordFetchers
    # ... process environment
    class BasicPasswordFetcher
      def call(_user_name)
        raise NotImplementedError, 'You need to implement `#call` for a valid password fetcher'
      end

      private

      def read(_string)
        raise NotImplementedError, 'You need to implement `#read` for a valid password fetcher'
      end

      # @param [String] user_name
      #
      # @raise [ArgumentError]
      #   Raised if password cannot be retrieved for user
      #
      # @return [String]
      #   The password
      def fetch_password_for_user(user_name)
        if read(user_name.upcase)
          read(user_name.upcase)
        elsif read(user_name.downcase)
          read(user_name.downcase)
        elsif read(user_name)
          read(user_name)
        else
          raise ArgumentError, %(Failed to fetch password for username "#{user_name}")
        end
      end
    end
  end
end
