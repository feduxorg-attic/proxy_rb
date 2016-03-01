require 'proxy_rb/drivers/basic_driver'
require 'capybara/webkit'

module ProxyRb
  module Drivers
    class WebkitDriver < BasicDriver
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
          ::Capybara::Webkit::Driver.new(app, options)
        end

        ::Capybara.run_server = false
        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Webkit::TimeoutError]
      end
    end
  end
end
