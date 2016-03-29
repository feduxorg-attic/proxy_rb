# frozen_string_literal: true
require 'proxy_rb/http_proxy'
require 'proxy_rb/proxy_url_parser'

Given(/^I use the user "([^"]*)"(?: with password "([^"]*)")?$/) do |user_name, password|
  u = OpenStruct.new
  u.name     = user_name
  u.password = password || password(user_name)

  users << u
end

Given(/^I use the following proxies:$/) do |table|
  @proxies = table.hashes.map do |r|
    p = ProxyRb::HttpProxy.new(ProxyRb::ProxyUrlParser.new(r[:proxy]))
    p.credentials.password = password(p.credentials.user_name) if p.credentials.password == '<PASSWORD>'

    unless users.nil? || users.empty?
      p.credentials.user_name = users.first.name
      p.credentials.password  = users.first.password
    end

    p
  end
end

Then(/the following requests are( not)? allowed to pass the proxy:/) do |forbidden, table|
  requests = []

  proxies.each do |proxy|
    table.hashes.map { |r| r[:url] }.each do |r|
      visit r, proxy
      requests << page.dup
    end
  end

  if forbidden
    expect(requests).to ProxyRb::Matchers.all be_forbidden
  else
    expect(requests).to ProxyRb::Matchers.all be_successful
  end
end

When(/^I visit "([^"]*)"$/) do |url|
  websites << url
end

When(/^I visit the following websites:$/) do |table|
  websites.concat table.hashes.map { |r| r[:url] }
end

Then(/the (?:last response|last requested page) should( not)? contain:/) do |not_expected, content|
  proxies.each do |proxy|
    visit websites.last, proxy

    if not_expected
      expect(page).not_to have_content content
    else
      expect(page).to have_content content
    end
  end
end

Then(/all (?:requested pages|responses) should( not)? contain:/) do |not_expected, content|
  results = []

  proxies.each do |proxy|
    websites.each do |w|
      visit w, proxy
      results << page.dup
    end
  end

  if not_expected
    expect(results).not_to ProxyRb::Matchers.include have_content content
  else
    expect(results).to ProxyRb::Matchers.all have_content content
  end
end
