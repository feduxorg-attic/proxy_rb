# frozen_string_literal: true
require 'proxy_rb/main'

Before do
  setup_proxy_rb
end

ProxyRb::ANNOUNCERS.each do |announcer|
  Before "@announce-#{announcer.to_s.tr('_', '-')}" do
    proxy_rb.announcer.activate(announcer)
  end
end

Before '@announce' do
  ProxyRb::ANNOUNCERS.each do |announcer|
    proxy_rb.announcer.activate(announcer)
  end
end
