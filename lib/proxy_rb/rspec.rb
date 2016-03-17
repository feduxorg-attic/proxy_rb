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

  # Setup ProxyRb
  config.before :each do |_example|
    next unless self.class.include? ProxyRb::Api

    setup_proxy_rb
  end

  config.before :each do |example|
    next unless self.class.include? ProxyRb::Api

    example.metadata.each { |k, v| proxy_rb.config.set_if_option(k, v) }
  end

  # Activate announcers based on rspec metadata
  config.before :each do |example|
    next unless self.class.include? ProxyRb::Api

    proxy_rb.announcer.activate(:proxy) if example.metadata[:announce_proxy]
    proxy_rb.announcer.activate(:proxy_user) if example.metadata[:announce_proxy_user]
    proxy_rb.announcer.activate(:resource) if example.metadata[:announce_resource]
    proxy_rb.announcer.activate(:resource_user) if example.metadata[:announce_resource_user]

    if example.metadata[:announce]
      proxy_rb.announcer.activate(:proxy)
      proxy_rb.announcer.activate(:proxy_user)
      proxy_rb.announcer.activate(:resource)
      proxy_rb.announcer.activate(:resource_user)
    end
  end
end
