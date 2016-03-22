# frozen_string_literal: true
require 'shellwords'
require 'proxy_rb/colorizer'
require 'proxy_rb/simple_table'

ProxyRb::AnsiColor.coloring = false if !STDOUT.tty? && !ENV.key?('AUTOTEST')

# ProxyRb
module ProxyRb
  # Announcer
  #
  # @private
  #
  # @example Activate your you own channel in cucumber
  #
  #   Before('@announce-my-channel') do
  #     aruba.announcer.activate :my_channel
  #   end
  #
  # @example Activate your you own channel in rspec > 3
  #
  #   before do
  #     current_example = context.example
  #     aruba.announcer.activate :my_channel if current_example.metadata[:announce_my_channel]
  #   end
  #
  #   ProxyRb.announcer.announce(:my_channel, 'my message')
  #
  class Announcer
    # Announcer using Kernel.puts
    class KernelPutsAnnouncer
      def announce(message)
        Kernel.puts message
      end

      def mode?(m)
        :kernel_puts == m
      end
    end

    # Announcer using Main#puts
    class PutsAnnouncer
      def announce(message)
        puts message
      end

      def mode?(m)
        :puts == m
      end
    end

    private

    attr_reader :announcers, :announcer, :channels, :output_formats, :colorizer

    public

    def initialize(*args)
      @announcers = []
      @announcers << PutsAnnouncer.new
      @announcers << KernelPutsAnnouncer.new

      @colorizer = ProxyRb::Colorizer.new

      @announcer         = @announcers.first
      @channels          = {}
      @output_formats    = {}

      @options           = args[1] || {}

      after_init
    end

    private

    def after_init
      output_format :proxy, proc { |v| format('Proxy: %s', v) }
      output_format :proxy_user, proc { |v| format('Proxy User: %s', v) }
      output_format :resource_user, proc { |v| format('Resource User: %s', v) }
      output_format :resource, proc { |v| format('Resource: %s', v) }
      output_format :http_response_headers, proc { |v| format("<<-HTTP_RESPONSE_HEADERS\n%s\nHTTP_RESPONSE_HEADERS", SimpleTable.new(v)) }
    end

    def output_format(channel, string = '%s', &block)
      output_formats[channel.to_sym] = if block_given?
                                         block
                                       elsif string.is_a?(Proc)
                                         string
                                       else
                                         proc { |*args| format(string, *args) }
                                       end
    end

    public

    # Reset announcer
    def reset
      @announcer = @announcers.first
    end

    # Change mode of announcer
    #
    # @param [Symbol] m
    #   The mode to set
    def mode=(m)
      @announcer = @announcers.find { |_a| f.mode? m.to_sym }

      self
    end

    # Check if channel is activated
    #
    # @param [Symbol] channel
    #   The name of the channel to check
    def activated?(channel)
      channels[channel.to_sym] == true
    end

    # Activate a channel
    #
    # @param [Symbol] channel
    #   The name of the channel to activate
    def activate(*chns)
      chns.flatten.each { |c| channels[c.to_sym] = true }

      self
    end

    # Announce information to channel
    #
    # @param [Symbol] channel
    #   The name of the channel to check
    #
    # @param [Array] args
    #   Arguments
    #
    # @yield
    #   If block is given, that one is called and the return value is used as
    #   message to be announced.
    def announce(channel, *args, &_block)
      channel = channel.to_sym

      the_output_format = if output_formats.key? channel
                            output_formats[channel]
                          else
                            proc { |v| format('%s', v) }
                          end

      return unless activated?(channel)

      message = if block_given?
                  the_output_format.call(yield)
                else
                  the_output_format.call(*args)
                end
      message += "\n"
      message = colorizer.cyan(message)

      announcer.announce(message)

      nil
    end
  end
end
