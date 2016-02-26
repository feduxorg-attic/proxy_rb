require 'capybara/poltergeist'

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

          def register_capybara_driver_for_proxy(proxy)
            options = {
              phantomjs_options: proxy.to_phantom_js,
              js_errors: false,
              phantomjs_logger: $stderr
            }

            ::Capybara.register_driver proxy.to_sym do |app|
              ::Capybara::Poltergeist::Driver.new(app, options)
            end
            require 'pry'
            binding.pry

            ::Capybara.run_server = false
            ::Capybara.current_driver = proxy.to_sym
          end
        end
      end

      # For http proxy
      module HttpProxy
        include ::Capybara::DSL

        def proxy
          ProxyRb::HttpProxy.new(subject)
        end

        def visit(url)
          resource = Resource.new(url)

          NonIncludes.clear_environment
          NonIncludes.register_capybara_driver_for_proxy(proxy)

          begin
            super(resource.to_uri)
          rescue ::Capybara::Poltergeist::TimeoutError
            raise ProxyRb::UrlTimeoutError, "Failed to fetch #{resource.to_uri}: Timeout occured."
          end
        end
        alias download visit 

        private

        def _clear_environment
          %w(
            http_proxy
            https_proxy
            HTTP_PROXY
            HTTPS_PROXY
          ).each { |v| ENV.delete v }
        end

        def _register_capybara_driver_for_proxy
          options = {
            phantomjs_options: proxy.to_phantom_js,
            js_errors: false,
            phantomjs_logger: $stderr
          }

          ::Capybara.register_driver proxy.to_sym do |app|
            ::Capybara::Poltergeist::Driver.new(app, options)
          end

          ::Capybara.run_server = false
          ::Capybara.current_driver = proxy.to_sym
        end
      end
    end
  end
end
