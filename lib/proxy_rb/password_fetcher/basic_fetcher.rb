module ProxyRb
  # Fetch password for user...
  module PasswordFetcher
    # ... process environment
    class BasicFetcher
      def call(user_name)
        fail NotImplementedError, 'You need to implement `#call` for a valid password fetcher'
      end
    end
  end
end
