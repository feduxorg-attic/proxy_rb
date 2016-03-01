# frozen_string_literal: true
require 'proxy_rb/drivers/basic_driver'
require 'capybara'

begin
  require 'capybara/poltergeist'
rescue LoadError
  ProxyRb.logger.error %(Error loading `poltergeist`-gem. Please add `gem poltergeist` to your `Gemfile`)
  exit 1
end

# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Driver for Poltergeist
    class PoltergeistDriver < BasicDriver
      # Register proxy
      #
      # @param [HttpProxy] proxy
      #   The HTTP proxy which should be used for fetching content
      def register(proxy)
        if proxy.empty?
          ::Capybara.current_driver = :poltergeist
          return
        end

        cli_parameters = []
        cli_parameters << "--proxy=#{proxy.url}" unless proxy.url.empty?
        cli_parameters << "--proxy-auth=#{proxy.credentials}" unless proxy.credentials.empty?

        options = {
          phantomjs_options: cli_parameters,
          js_errors: false,
          phantomjs_logger: $stderr
        }

        ::Capybara.register_driver proxy.to_ref do |app|
          ::Capybara::Poltergeist::Driver.new(app, options)
        end

        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Poltergeist::TimeoutError]
      end
    end
  end
end
