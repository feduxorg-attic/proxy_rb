# frozen_string_literal: true
Before do
  setup_proxy_rb
end

%i(
  proxy
  proxy_user
  resource
  resource_user
  http_response_headers
).each do |announcer|
  Before "@announce-#{announcer.to_s.gsub(/_/, '-')}" do
    proxy_rb.announcer.activate(announcer)
  end
end

Before '@announce' do
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
