require 'contracts'

require 'proxy_rb/version'
require 'proxy_rb/basic_configuration'
require 'proxy_rb/basic_configuration/in_config_wrapper'
require 'proxy_rb/password_fetcher/env'

# ProxyRb
module ProxyRb
  # ProxyRb Configuration
  #
  # This defines the configuration options of proxy_rb
  class Configuration < BasicConfiguration
    option_accessor :password_fetcher, contract: { PasswordFetcher::BasicFetcher => PasswordFetcher::BasicFetcher }, default: ProxyRb::PasswordFetcher::Env.new
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
