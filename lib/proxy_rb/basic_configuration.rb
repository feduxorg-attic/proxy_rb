# frozen_string_literal: true
require 'contracts'
require 'proxy_rb/basic_configuration/option'
require 'proxy_rb/basic_configuration/in_configuration_wrapper'

# ProxyRb
module ProxyRb
  # Basic configuration
  class BasicConfiguration
    include Contracts

    class << self
      def known_options
        @known_options ||= {}
      end

      # Define an option reader
      #
      # @param [Symbol] name
      #   The name of the reader
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Class, Module] contract
      #   The contract for the option
      #
      # @option [Object] default
      #   The default value
      def option_reader(name, opts = {})
        contract = opts[:contract]
        default  = opts[:default]

        raise ArgumentError, 'Either use block or default value' if block_given? && default
        raise ArgumentError, 'contract-options is required' if contract.nil?

        Contract contract
        add_option(name, block_given? ? yield(InConfigurationWrapper.new(known_options)) : default)

        define_method(name) { find_option(name).value }

        self
      end

      # Define an option reader and writer
      #
      # @param [Symbol] name
      #   The name of the reader
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Class, Module] contract
      #   The contract for the option
      #
      # @option [Object] default
      #   The default value
      def option_accessor(name, opts = {})
        contract = opts[:contract]
        default  = opts[:default]

        raise ArgumentError, 'Either use block or default value' if block_given? && default
        # fail ArgumentError, 'Either use block or default value' if !block_given? && default.nil? && default.to_s.empty?
        raise ArgumentError, 'contract-options is required' if contract.nil?

        # Add writer
        add_option(name, block_given? ? yield(InConfigWrapper.new(known_options)) : default)

        Contract contract
        define_method("#{name}=") { |v| find_option(name).value = v }

        # Add reader
        option_reader name, contract: { None => contract.values.first }
      end

      private

      def add_option(name, value = nil)
        return if known_options.key?(name)

        known_options[name] = Option.new(name: name, value: value)

        self
      end
    end

    protected

    attr_accessor :local_options

    public

    # Create configuration
    def initialize
      initialize_configuration
    end

    # @yield [Configuration]
    #
    #   Yields self
    def configure
      yield self if block_given?
    end

    # Reset configuration
    def reset
      initialize_configuration
    end

    # Make deep dup copy of configuration
    def make_copy
      obj = dup
      obj.local_options = Marshal.load(Marshal.dump(local_options))

      obj
    end

    # Check if <name> is option
    #
    # @param [String, Symbol] name
    #   The name of the option
    def option?(name)
      local_options.any? { |_, v| v.name == name.to_sym }
    end

    def ==(other)
      local_options.values.map(&:value) == other.local_options.values.map(&:value)
    end

    # Set if name is option
    def set_if_option(name, *args)
      send("#{name}=".to_sym, *args) if option? name
      public_send("#{name}=".to_sym, *args) if option? name
    end

    private

    def initialize_configuration
      @local_options = Marshal.load(Marshal.dump(self.class.known_options))
    end

    def find_option(name)
      raise NotImplementedError, %(Unknown option "#{name}") unless option? name

      local_options[name]
    end
  end
end
