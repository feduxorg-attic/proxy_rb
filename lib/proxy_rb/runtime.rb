# frozen_string_literal: true
require 'proxy_rb/configuration'
require 'proxy_rb/configuration_wrapper'
require 'proxy_rb/events'
require 'proxy_rb/event_bus'
require 'proxy_rb/announcer'

module ProxyRb
  # Runtime of proxy_rb
  #
  # Most methods are considered private. Please look for `(private)` in the
  # attribute descriptions. Only a few like `#current_directory`,
  # '#root_directory` and `#config` are considered to be part of the public
  # API.
  class Runtime
    # @!attribute [r] config
    #   Access configuration of proxy_rb
    #
    # @!attribute [r] announcer
    #   Announce information
    #
    # @!attribute [r] event_bus
    #   Handle events (private)
    #
    attr_accessor :config, :announcer, :event_bus

    def initialize(opts = {})
      @event_bus       = EventBus.new(EventBus::NameResolver.new(ProxyRb::Events))
      @announcer       = opts.fetch(:announcer, ProxyRb::Announcer.new)
      @config          = opts.fetch(:config, ConfigurationWrapper.new(ProxyRb.config.make_copy, @event_bus))

      @setup_done = false
    end

    # @private
    #
    # Setup of proxy_rb is finshed. Should be used only internally.
    def setup_done
      @setup_done = true
    end

    # @private
    #
    # Has proxy_rb already been setup. Should be used only internally.
    def setup_already_done?
      @setup_done == true
    end
  end
end
