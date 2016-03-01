require 'proxy_rb/drivers/basic_driver'
require 'capybara/poltergeist'

module ProxyRb
  module Drivers
    class PoltergeistDriver < BasicDriver
      def register(proxy)
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

      def rescuable_errors
        [::Capybara::Poltergeist::TimeoutError]
      end
    end
  end
end
