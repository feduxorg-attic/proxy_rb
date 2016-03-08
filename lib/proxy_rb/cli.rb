require 'thor'
require 'proxy_rb/console'
require 'proxy_rb/initializer'

# ProxyRb
module ProxyRb
  # Command line Interface
  #
  # @private
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc 'console', "Start proxy_rb's console"
    def console
      ProxyRb::Console.new.start
    end

    desc 'init', 'Initialize proxy_rb'
    option :test_framework, :default => 'rspec', :enum => %w(rspec), :desc => 'Choose which test framework to use'
    def init
      ProxyRb::Initializer.new.call(options[:test_framework])
    end
  end
end
