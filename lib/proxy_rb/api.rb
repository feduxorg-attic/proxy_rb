require 'rspec/matchers'
require 'capybara/rspec'

require 'proxy_rb/no_proxy'
require 'proxy_rb/main'
ProxyRb.require_files_matching_pattern('../api/*.rb')
ProxyRb.require_files_matching_pattern('../matchers/*.rb')

module ProxyRb
  module Api
    include ProxyRb::Helpers::HttpProxy
    include ProxyRb::Helpers::Password
    include Capybara::RSpecMatchers
  end
end
