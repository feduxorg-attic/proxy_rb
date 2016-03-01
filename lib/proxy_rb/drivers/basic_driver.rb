# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # Drivers
  module Drivers
    # Basic Driver
    class BasicDriver
      # Register proxy
      def register(_proxy)
        raise NoMethodError, 'You need to implement this in your driver'
      end
    end
  end
end
