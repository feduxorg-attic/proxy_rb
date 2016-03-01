require 'proxy_rb/drivers/basic_driver'

begin
  require 'capybara/poltergeist'
rescue LoadError
  ProxyRb.logger.error %(Error loading `poltergeist`-gem. Please add `gem poltergeist` to your `Gemfile`)
  exit 1
end

module ProxyRb
  module Drivers
    class PoltergeistDriver < BasicDriver
      def register(proxy)
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

        ::Capybara.run_server = false
        ::Capybara.current_driver = proxy.to_ref
      end

      def rescuable_errors
        [::Capybara::Poltergeist::TimeoutError]
      end
    end
  end
end
