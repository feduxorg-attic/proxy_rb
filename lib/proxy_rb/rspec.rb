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

  # Output warnings
  config.before :suite do
    ProxyRb.logger.warn 'You disabled the "strict"-mode in your ProxyRb-configuration. You might not notice all errors.' if ProxyRb.config.strict == false
  end

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

    %i(
      proxy
      proxy_user
      resource
      resource_user
      http_response_headers
    ).each do |announcer|
      proxy_rb.announcer.activate(announcer) if example.metadata["announce_#{announcer}".to_sym]
    end

    if example.metadata[:announce]
      %i(
        proxy
        proxy_user
        resource
        resource_user
        http_response_headers
      ).each do |announcer|
        proxy_rb.announcer.activate(announcer)
      end
    end
  end
end
