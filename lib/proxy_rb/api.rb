# frozen_string_literal: true
require 'rspec/matchers'
require 'capybara/rspec'

require 'proxy_rb/no_proxy'
require 'proxy_rb/main'
ProxyRb.require_files_matching_pattern('api/*.rb')
ProxyRb.require_files_matching_pattern('matchers/*.rb')

# ProxyRb
module ProxyRb
  # Api
  module Api
    include ProxyRb::Api::Core
    include ProxyRb::Api::HttpProxy
    include ProxyRb::Api::Passwords
    include ProxyRb::Api::Formatters
    include Capybara::RSpecMatchers
  end
end
