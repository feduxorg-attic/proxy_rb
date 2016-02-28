require 'proxy_rb/password_fetcher/basic_fetcher'

module ProxyRb
  # Fetch password for user...
  module PasswordFetcher
    # ... process environment
    class Env < BasicFetcher
      def call(user_name)
        ENV[format('PASSWORD_%s', user_name.upcase)]
      end
    end
  end
end
