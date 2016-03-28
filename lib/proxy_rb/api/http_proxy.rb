# frozen_string_literal: true

require 'proxy_rb'
require 'proxy_rb/resource'
require 'proxy_rb/http_downloader'
require 'proxy_rb/http_proxy'
require 'proxy_rb/request'
require 'proxy_rb/response'
require 'proxy_rb/errors'

# Main Module
module ProxyRb
  # Api
  module Api
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
        @proxy ||= ProxyRb::HttpProxy.new(ProxyRb::ProxyUrlParser.new(subject))
      end

      # Visit an URL
      #
      # @param [String] url
      # rubocop:disable Metrics/AbcSize
      def visit(url, p = proxy)
        resource = Resource.new(url)

        proxy_rb.event_bus.notify Events::ResourceSet.new(resource.url.to_s)
        proxy_rb.event_bus.notify Events::ResourceUserSet.new(resource.credentials.to_s) unless resource.credentials.empty?

        NonIncludes.clear_environment
        NonIncludes.configure_driver

        proxy_rb.event_bus.notify Events::ProxySet.new(p.url.to_s)
        proxy_rb.event_bus.notify Events::ProxyUserSet.new(p.credentials.to_s) unless p.credentials.empty?

        NonIncludes.register_capybara_driver_for_proxy(p)

        proxy_rb.event_bus.notify Events::BeforeResourceFetched.new(page)

        begin
          super(resource.to_s)
        rescue *ProxyRb.config.driver.timeout_errors
          raise ProxyRb::UrlTimeoutError, "Failed to fetch #{resource}: Timeout occured."
        rescue *ProxyRb.config.driver.failure_errors => e
          raise ProxyRb::ResourceNotDownloadableError, "Failed to fetch #{resource}: #{e.message}."
        rescue => e
          raise ProxyRb::ResourceNotDownloadableError, "An unexpected error occured while fetching #{resource}: #{e.message}."
        end

        proxy_rb.event_bus.notify Events::AfterResourceFetched.new(page)
      end
      # rubocop:enable Metrics/AbcSize

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
