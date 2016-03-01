# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Basic Driver
    class BasicDriver
      # Configure driver
      def configure_driver
        ::Capybara.run_server = false
      end

      # Register proxy
      def register(_proxy)
        raise NoMethodError, 'You need to implement this in your driver'
      end
    end
  end
end
