require 'rspec'
require 'capybara/rspec'

require 'proxy_rb/main'

ProxyRb.require_files_matching_pattern('rspec/helpers/*.rb')
ProxyRb.require_files_matching_pattern('rspec/matchers/*.rb')
ProxyRb.require_files_matching_pattern('rspec/shared_examples/*.rb')
ProxyRb.require_files_matching_pattern('rspec/shared_contexts/*.rb')

# Main Module
module ProxyRb
  # Main Module
  module Rspec
  end
end

RSpec.configure do |config|
  config.include ProxyRb::Rspec::Helpers::HttpProxy, type: :http_proxy
  config.include ProxyRb::Rspec::Helpers::Passwords, type: :http_proxy
  # config.include Capybara::DSL, type: :http_proxy
  config.include Capybara::RSpecMatchers, type: :http_proxy
end
