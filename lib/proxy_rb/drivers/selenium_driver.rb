# frozen_string_literal: true
require 'proxy_rb/drivers/basic_driver'
require 'capybara'
require 'selenium-webdriver'

# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Driver for Selenium
    class SeleniumDriver < BasicDriver
      # Register proxy
      #
      # @param [HttpProxy] proxy
      #   The HTTP proxy which should be used for fetching content
      def register(proxy)
        if proxy.empty?
          ::Capybara.current_driver = :selenium
          return
        end

        options = {
          proxy: {
            http: proxy.url.to_s
          }
        }

        unless ::Capybara.drivers.key? proxy.to_ref
          ::Capybara.register_driver proxy.to_ref do |app|
            ::Capybara::Selenium::Driver.new(app, options)
          end
        end

        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Selenium::TimeoutError]
      end
    end
  end
end
