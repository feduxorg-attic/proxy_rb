# frozen_string_literal: true
require 'proxy_rb/drivers/basic_driver'

begin
  require 'capybara/webkit'
rescue LoadError
  ProxyRb.logger.error %(Error loading `capybara-webkit`-gem. Please add `gem capybara-webkit` to your `Gemfile`)
  exit 1
end

# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Driver for Capybara-Webkit
    class WebkitDriver < BasicDriver
      # Configure driver
      def configure_driver
        ::Capybara::Webkit.configure do |config|
          config.allow_unknown_urls
        end

        super
      end

      # Register proxy
      #
      # @param [HttpProxy] proxy
      #   The HTTP proxy which should be used for fetching content
      def register(proxy)
        options = {
          proxy: {
            host: proxy.host,
            port: proxy.port,
            user: proxy.user,
            pass: proxy.password
          }
        }

        ::Capybara.register_driver proxy.to_ref do |app|
          ::Capybara::Webkit::Driver.new(app, Capybara::Webkit::Configuration.to_hash.merge(options))
        end

        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Webkit::TimeoutError]
      end
    end
  end
end
