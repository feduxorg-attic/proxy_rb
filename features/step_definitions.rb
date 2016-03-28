# frozen_string_literal: true
require 'vault'
require 'json'
require 'webrick/httpauth/htpasswd'

Given(/^a spec file named "([^"]*)" with:$/) do |path, content|
  step %(a file named "#{File.join('spec', path)}" with:), content
end

Given(/^a feature file named "([^"]*)" with:$/) do |path, content|
  step %(a file named "#{File.join('features', path)}" with:), content
end

After do
  terminate_all_commands
end

Given(/^I use a simple web server$/) do
  step 'I use a web server with the following configuration:', table(%(|option | value |))
end

Given(/^I use a web server requiring authentication$/) do
  step 'I use a web server with the following configuration:', table(%(|option | value |))
end

Given(/^I use a virus blocking proxy(?: at "(.*)")?$/) do |path|
  path = 'bin/http_proxy' if path.nil? || path.empty?

  # rubocop:disable Metrics/LineLength
  hashes = [
    {
      option: 'status_code',
      value: 403
    },
    {
      option: 'body',
      value: 'Virus found!'
    },
    {
      option: 'expected_response_body',
      value: %w#X  5  O  !  P  %  @  A  P  [  4  \  P  Z  X  5  4  (  P  ^  )  7  C  C  )  7  }  $  E  I  C  A  R  -  S  T  A  N  D  A  R  D  -  A  N  T  I  V  I  R  U  S  -  T  E  S  T  -  F  I  L  E  !  $  H  +  H  *#.join('')
    }
  ]
  # rubocop:enable Metrics/LineLength

  step %(an executable named "#{path}" with:), Test::ProxyGenerator.new.render(hashes)
end

Given(/^I use a virus infected web server(?: at "(.*)")?$/) do |path|
  path = 'bin/http_server' if path.nil? || path.empty?

  # The last one wins:
  # If the user sets the user_datas herself, this will be used
  # rubocop:disable Metrics/LineLength
  hashes = [
    {
      option: 'body',
      value: %w#X  5  O  !  P  %  @  A  P  [  4  \  P  Z  X  5  4  (  P  ^  )  7  C  C  )  7  }  $  E  I  C  A  R  -  S  T  A  N  D  A  R  D  -  A  N  T  I  V  I  R  U  S  -  T  E  S  T  -  F  I  L  E  !  $  H  +  H  *#.join('')
    },
    {
      option: 'status_code',
      value: 200
    }
  ]
  # rubocop:enable Metrics/LineLength

  step %(an executable named "#{path}" with:), Test::WebServerGenerator.new.render(hashes)
end

Given(/^I use a web server(?: at "(.*)")? with the following configuration:/) do |path, table|
  path = 'bin/http_server' if path.nil? || path.empty?

  # The last one wins:
  # If the user sets the user_datas herself, this will be used
  hashes = [
    {
      option: 'user_database',
      value: expand_path('config/htpasswd.web_server')
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
      value: expand_path('config/htpasswd.proxy')
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

Given(/^the following local users are authorized to use the (proxy|web server):$/) do |type, table|
  create_directory('config')

  htpasswd = if type == 'proxy'
               WEBrick::HTTPAuth::Htpasswd.new expand_path('config/htpasswd.proxy')
             elsif type == 'web server'
               WEBrick::HTTPAuth::Htpasswd.new expand_path('config/htpasswd.web_server')
             else
               raise ArgumentError, 'Only "proxy" and "web server" are allowed'
             end

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
