# frozen_string_literal: true
require 'proxy_rb/runtime'
require 'proxy_rb/setup'

# Main Module
module ProxyRb
  # Api
  module Api
    # Core Module
    module Core
      # Aruba Runtime
      def proxy_rb
        @_proxy_rb_runtime ||= Runtime.new
      end

      # Setup everything to make proxy_rb work
      #
      def setup_proxy_rb
        ProxyRb::Setup.new(proxy_rb).call

        nil
      end
    end
  end
end
