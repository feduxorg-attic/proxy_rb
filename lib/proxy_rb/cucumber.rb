# frozen_string_literal: true
require 'proxy_rb'
require 'proxy_rb/api'

# Main Module
module ProxyRb
  # Main Module
  module Cucumber
    include ProxyRb::Api

    attr_reader :proxy

    def proxies
      @proxies ||= []
    end

    def websites
      @websites ||= []
    end

    def users
      @users ||= []
    end
  end
end

World(ProxyRb::Cucumber)

require 'proxy_rb/cucumber/hooks'
ProxyRb.require_files_matching_pattern('cucumber/*.rb')

ProxyRb.logger.warn 'You disabled the "strict"-mode in your ProxyRb-configuration. You might not notice all errors.' if ProxyRb.config.strict == false
