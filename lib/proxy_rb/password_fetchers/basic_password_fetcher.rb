module ProxyRb
  # Fetch password for user...
  module PasswordFetchers
    # ... process environment
    class BasicPasswordFetcher
      def call(_user_name)
        raise NotImplementedError, 'You need to implement `#call` for a valid password fetcher'
      end
    end
  end
end
