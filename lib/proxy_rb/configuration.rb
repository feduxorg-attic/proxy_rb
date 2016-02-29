require 'contracts'

require 'proxy_rb/version'
require 'proxy_rb/basic_configuration'
require 'proxy_rb/basic_configuration/in_config_wrapper'

require 'proxy_rb/password_fetchers/basic_password_fetcher'
require 'proxy_rb/password_fetchers/environment_password_fetcher'

# ProxyRb
module ProxyRb
  # ProxyRb Configuration
  #
  # This defines the configuration options of proxy_rb
  class Configuration < BasicConfiguration
    option_accessor :password_fetcher, contract: { PasswordFetchers::BasicPasswordFetcher => PasswordFetchers::BasicPasswordFetcher }, default: ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'SECRET')
  end
end

# ProxyRb
module ProxyRb
  @config = Configuration.new

  class << self
    attr_reader :config

    # Configure proxy_rb
    #
    # @example How to configure proxy_rb
    #
    #   ProxyRb.configure do |config|
    #     config.<option> = <value>
    #   end
    #
    def configure(&block)
      @config.configure(&block)

      self
    end
  end
end
