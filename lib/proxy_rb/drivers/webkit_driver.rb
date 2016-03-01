require 'proxy_rb/drivers/basic_driver'
require 'capybara/webkit'

module ProxyRb
  module Drivers
    class WebkitDriver < BasicDriver
      def register(proxy)
        options = {
          proxy: proxy.to_hash,
        }

        ::Capybara.register_driver proxy.to_sym do |app|
          ::Capybara::Webkit::Driver.new(app, options)
        end

        ::Capybara.run_server = false
        ::Capybara.current_driver = proxy.to_sym
      end

      def rescuable_errors
        [::Capybara::Webkit::TimeoutError]
      end
    end
  end
end
