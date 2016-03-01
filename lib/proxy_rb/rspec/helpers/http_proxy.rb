# frozen_string_literal: true

require 'proxy_rb'
require 'proxy_rb/resource'
require 'proxy_rb/http_downloader'
require 'proxy_rb/http_proxy'
require 'proxy_rb/request'
require 'proxy_rb/response'

# Main Module
module ProxyRb
  # Main Module
  module Rspec
    # Helpers
    module Helpers
      # Non includable internal helper methods
      #
      # Not for use by normal users
      module NonIncludes
        class << self
          def clear_environment
            %w(
              http_proxy
              https_proxy
              HTTP_PROXY
              HTTPS_PROXY
            ).each { |v| ENV.delete v }
          end

          def configure_driver
            ProxyRb.config.driver.configure_driver
          end

          def register_capybara_driver_for_proxy(proxy)
            ProxyRb.config.driver.register proxy
          end
        end
      end

      # For http proxy
      module HttpProxy
        include ::Capybara::DSL

        # The proxy based on subject
        def proxy
          ProxyRb::HttpProxy.new(ProxyUrlParser.new(subject))
        end

        # Visit an URL
        #
        # @param [String] url
        def visit(url)
          resource = Resource.new(url)

          NonIncludes.clear_environment
          NonIncludes.configure_driver
          NonIncludes.register_capybara_driver_for_proxy(proxy)

          begin
            super(resource.to_url)
          rescue ProxyRb.config.driver.rescuable_errors
            raise ProxyRb::UrlTimeoutError, "Failed to fetch #{resource.to_url}: Timeout occured."
          end
        end

        # !@method download
        #
        # @see #visit
        alias download visit

        # Get access to the request made
        def request
          Request.new(page)
        end

        # Get access to the response get
        def response
          Response.new(page)
        end
      end
    end
  end
end
