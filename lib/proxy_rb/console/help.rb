# frozen_string_literal: true
require 'proxy_rb/api'

# ProxyRb
module ProxyRb
  # Consule
  class Console
    # Helpers for ProxyRb::Console
    module Help
      # Output help information
      def proxy_rb_help
        puts 'ProxyRb Version: ' + ProxyRb::VERSION
        puts 'Issue Tracker: ' + 'https://github.com/fedux-org/proxy_rb/issues'
        puts "Documentation:\n" + %w(http://www.rubydoc.info/gems/proxy_rb).map { |d| format('* %s', d) }.join("\n")
        puts

        nil
      end

      # List available methods in proxy_rb
      def proxy_rb_methods
        ms = (ProxyRb::Api.instance_methods - Module.instance_methods).each_with_object([]) { |e, a| a << format('* %s', e) }.sort
        puts "Available Methods:\n" + ms.join("\n")

        nil
      end
    end
  end
end
