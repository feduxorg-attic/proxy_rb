# frozen_string_literal: true
require 'proxy_rb/http_proxy'
require 'proxy_rb/proxy_url_parser'

Given(/^I use the user "([^"]*)"(?: with password "([^"]*)")?$/) do |user_name, password|
  u = OpenStruct.new
  u.name     = user_name
  u.password = password || password(user_name)

  users << u

  proxies.each do |p|
    p.credentials.user_name = users.last.name
    p.credentials.password  = users.last.password
  end
end

Given(/^I use the following proxies:$/) do |table|
  new_proxies = table.hashes.map do |r|
    p = ProxyRb::HttpProxy.new(ProxyRb::ProxyUrlParser.new(r[:proxy]))

    # Hide password by using <PASSWORD> => retrieve it using fetcher
    if p.credentials.password == '<PASSWORD>'
      p.credentials.password = password(p.credentials.user_name)
      next p
    end

    # Username and password are already set
    next p if p.credentials.password && p.credentials.user_name

    # No users have be defined
    next p if users.nil? || users.empty?

    # Use last user since nothing else makes sense
    p.credentials.user_name = users.last.name
    p.credentials.password  = users.last.password

    p
  end

  proxies.concat new_proxies
end

Then(/the following requests are( not)? allowed to pass the proxy:/) do |forbidden, table|
  step 'I visit the following websites:', table

  if forbidden
    step 'all requests are not allowed to pass the proxy:'
  else
    step 'all requests are allowed to pass the proxy'
  end
end

Then(/all requests are( not)? allowed to pass the proxy/) do |forbidden|
  results = []

  proxies.each do |proxy|
    websites.each do |w|
      visit w, proxy
      results << page.dup
    end
  end

  if forbidden
    expect(results).to ProxyRb::Matchers.all be_forbidden
  else
    expect(results).to ProxyRb::Matchers.all be_successful
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
