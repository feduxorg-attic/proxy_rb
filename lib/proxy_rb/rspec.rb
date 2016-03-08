# frozen_string_literal: true
require 'proxy_rb/api'

# Main Module
module ProxyRb
  # Main Module
  module Rspec
  end
end

RSpec.configure do |config|
  config.include ProxyRb::Api, type: :http_proxy
end
