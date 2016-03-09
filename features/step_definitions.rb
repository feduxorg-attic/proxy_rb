# frozen_string_literal: true
require 'vault'
require 'json'

Given(/^a spec file named "([^"]*)" with:$/) do |path, content|
  step %(a file named "#{File.join('spec', path)}" with:), content
end

After do
  terminate_all_commands
end

Given(/^I use a simple web server$/) do
  step 'I use a web server with the following configuration:' , table(%(|option | value |))
end

Given(/^I use a simple web server requiring authentication$/) do
  step 'I use a web server with the following configuration:' , table(%(|option | value |))
end

Given(/^I use a web server(?: at "(.*)")? with the following configuration:/) do |path, table|
  path = 'bin/http_server' if path.nil? || path.empty?

  # The last one wins:
  # If the user sets the user_datas herself, this will be used
  hashes = [
    {
      option: 'user_database',
      value: expand_path('config/htpasswd')
    }
  ].concat table.hashes

  step %(an executable named "#{path}" with:), Test::WebServerGenerator.new.render(hashes)
end

Given(/^I use a proxy requiring authentication$/) do
  step 'I use a proxy with the following configuration:', table(%(|option | value |))
end

Given(/^I use a simple proxy$/) do
  step 'I use a proxy with the following configuration:', table(%(|option | value |))
end

Given(/^I use a proxy(?: at "(.*)")? with the following configuration:$/) do |path, table|
  path = 'bin/http_proxy' if path.nil? || path.empty?

  # The last one wins:
  # If the user sets the user_datas herself, this will be used
  hashes = [
    {
      option: 'user_database',
      value: expand_path('config/htpasswd')
    }
  ].concat table.hashes

  step %(an executable named "#{path}" with:), Test::ProxyGenerator.new.render(hashes)
end

Given(/^I use a local vault server with the following data at "(.*)":$/) do |mount_point, table|
  step 'I run `vault server -dev` in background'
  sleep 2

  table.hashes.each do |row|
    user     = row['user'].to_s
    password = row['password'].to_s

    Vault::Client.new(address: ENV['VAULT_ADDR']).logical.write(File.join(mount_point, user), password: password)
  end
end

Given(/^the following local users are authorized to use the (?:proxy|webserver):$/) do |table|
  require 'webrick/httpauth/htpasswd'
  create_directory('config')
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new expand_path('config/htpasswd')

  table.hashes.each do |row|
    user     = row['user'].to_s
    password = row['password'].to_s
    realm    = row.fetch('realm', 'Proxy Realm')

    htpasswd.set_passwd realm, user, password
  end

  htpasswd.flush
end

Then(/^the "([^"]*)"\-gem should be installed on the local system$/) do |name|
  run("gem list #{name}")
  expect(last_command_started).to have_output(/#{name}/)
end
