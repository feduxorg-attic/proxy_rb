# frozen_string_literal: true
require 'proxy_rb/drivers/basic_driver'

begin
  require 'capybara/webkit'
rescue LoadError
  ProxyRb.logger.error %(Error loading `capybara-webkit`-gem. Please add `gem capybara-webkit` to your `Gemfile`)
  exit 1
end

# rubocop:disable Style/SymbolProc
::Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end
# rubocop:enable Style/SymbolProc

# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Driver for Capybara-Webkit
    class WebkitDriver < BasicDriver
      # Register proxy
      #
      # @param [HttpProxy] proxy
      #   The HTTP proxy which should be used for fetching content
      def register(proxy)
        if proxy.empty?
          ::Capybara.current_driver = :webkit
          return
        end

        options = {
          proxy: {
            host: proxy.host,
            port: proxy.port,
            user: proxy.user,
            pass: proxy.password
          }
        }

        unless ::Capybara.drivers.key? proxy.to_ref
          ::Capybara.register_driver proxy.to_ref do |app|
            ::Capybara::Webkit::Driver.new(app, Capybara::Webkit::Configuration.to_hash.merge(options))
          end
        end

        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Webkit::TimeoutError]
      end
    end
  end
end
