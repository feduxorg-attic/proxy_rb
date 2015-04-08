require 'rspec'
require 'capybara/poltergeist'
require 'capybara/rspec'

require 'proxy_rb/rspec'

ProxyRb.require_file_matching_pattern('rspec/helpers/*.rb')
ProxyRb.require_file_matching_pattern('rspec/matchers/*.rb')
ProxyRb.require_file_matching_pattern('rspec/shared_examples/*.rb')
ProxyRb.require_file_matching_pattern('rspec/shared_contexts/*.rb')

# Main Module
module ProxyRb
  # Main Module
  module Rspec
  end
end

RSpec.configure do |config|
  config.include ProxyRb::Rspec::Helpers::HttpProxy, type: :http_proxy
end
