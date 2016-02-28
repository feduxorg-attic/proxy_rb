require 'proxy_rb/password_fetcher/basic_fetcher'

require 'pry'
binding.pry

begin
  require 'vault'
rescue LoadError
  ProxyRb.logger.error 'Please add `vault` to your `Gemfile` to use this password fetcher'
end

module ProxyRb
  # Fetch password for user...
  module PasswordFetcher
    # ... from HashiCorp Vault
    class Vault < BasicFetcher
      def call(user_name)
        Vault.with_retries(Vault::HTTPConnectionError, Vault::HTTPError) do |attempt, e|
          Vault.logical.read(format('proxy/user/%s', user_name))
        end
      end
    end
  end
end
