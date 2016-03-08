# frozen_string_literal: true
require 'proxy_rb/drivers/basic_driver'
require 'capybara'
require 'selenium-webdriver'
require 'proxy_rb/errors'

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

        profile = Selenium::WebDriver::Firefox::Profile.new
        # profile.proxy = Selenium::WebDriver::Proxy.new(http: proxy.full_url)
        profile.proxy = Selenium::WebDriver::Proxy.new(http: format('%s:%s', proxy.host, proxy.port))

        unless ::Capybara.drivers.key? proxy.to_ref
          ::Capybara.register_driver proxy.to_ref do |app|
            ::Capybara::Selenium::Driver.new(app, profile: profile)
          end
        end

        ::Capybara.current_driver = proxy.to_ref
      end

      def timeout_errors
        []
      end

      def failure_errors
        []
      end
    end
  end
end
