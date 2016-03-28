# frozen_string_literal: true
require 'thor/group'
require 'thor/actions'

# ProxyRb
module ProxyRb
  # Initializers
  #
  # Initialize project with proxy_rb configuration files
  module Initializers
    # Common initializer
    #
    # @private
    class CommonInitializer < Thor::Group
      include Thor::Actions

      # Add gem to gemfile
      def add_gem
        file = 'Gemfile'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        content = if File.exist? file
                    %(gem 'proxy_rb', '~> #{ProxyRb::VERSION}')
                  else
                    %(source 'https://rubygems.org'\ngem 'proxy_rb', '~> #{ProxyRb::VERSION}'\n)
                  end
        send creator, file, content
      end
    end
  end
end

# ProxyRb
module ProxyRb
  # Initializer
  module Initializers
    # Add proxy_rb + rspec to project
    #
    # @private
    class RSpecInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          :rspec == framework.downcase.to_sym
        end
      end

      def create_helper
        file = 'spec/spec_helper.rb'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        send creator, file, <<~EOS
        $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

        ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
        ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
        EOS
      end

      def create_support_file
        create_file 'spec/support/proxy_rb.rb', <<~EOS
        require 'proxy_rb/rspec'
        EOS
      end
    end
  end
end

# ProxyRb
module ProxyRb
  # Initializer
  module Initializers
    # Add proxy_rb + rspec to project
    #
    # @private
    class CucumberInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          :cucumber == framework.downcase.to_sym
        end
      end

      def create_helper; end

      def create_support_file
        create_file 'features/support/proxy_rb.rb', <<~EOS
        require 'proxy_rb/cucumber'
        EOS
      end
    end
  end
end

# ProxyRb
module ProxyRb
  # The whole initializer
  #
  # This one uses the specific initializers to generate the needed files.
  #
  # @private
  class Initializer
    private

    attr_reader :initializers

    public

    def initialize
      @initializers = []
      @initializers << Initializers::RSpecInitializer
      @initializers << Initializers::CucumberInitializer
    end

    # Create files etc.
    def call(test_framework)
      begin
        initializers.find { |i| i.match? test_framework }.start [], {}
      rescue ArgumentError => e
        $stderr.puts e.message
        exit 0
      end

      Initializers::CommonInitializer.start [], {}
    end
  end
end
