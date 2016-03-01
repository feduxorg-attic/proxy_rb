# frozen_string_literal: true
require 'vault'
require 'json'

Given(/^a spec file named "([^"]*)" with:$/) do |path, content|
  step %(a file named "#{File.join('spec', path)}" with:), content
end

After do
  terminate_all_commands
end

Given(/^I append "(.*)" to the environment variable "(.*)"/) do |variable, value|
  append_environment_variable(variable.to_s, value.to_s)
end

Given(/^I look for executables in "(.*)" within the current directory$/) do |directory|
  prepend_environment_variable 'PATH', expand_path(directory) + ':'
end

Given(/^I use a simple web server(?: at "(.*)")?$/) do |path|
  name = if path
           %(I use a web server at "#{path}" with the following configuration:)
         else
           'I use a web server with the following configuration:'
         end
  step name, table(%(|option | value |))
end

Given(/^I use a web server(?: at "(.*)")? with the following configuration:/) do |path, table|
  path = 'bin/http_server' if path.nil? || path.empty?

  step %(an executable named "#{path}" with:), WebServerGenerator.new.render(table)
end

Given(/^I use a proxy requiring authentication$/) do
  step 'I use a proxy requiring authentication with the following configuration:', table(%(|option | value |))
end

Given(/^I use a proxy(?: at "(.*)")? requiring authentication with the following configuration:$/) do |path, table|
  path = 'bin/http_proxy' if path.nil? || path.empty?

  step %(an executable named "#{path}" with:), ProxyGenerator.new(type: :authentication).render(table)
end

Given(/^I use a simple standard proxy$/) do
  step 'I use a proxy with the following configuration:', table(%(|option | value |))
end

Given(/^I use a proxy(?: at "(.*)")? with the following configuration:$/) do |path, table|
  path = 'bin/http_proxy' if path.nil? || path.empty?

  step %(an executable named "#{path}" with:), ProxyGenerator.new(type: :simple).render(table)
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
