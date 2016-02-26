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

Given(/^I use a proxy requiring authentication/) do
  step 'I set the environment variable "PROXY_TYPE" to "authentication_proxy"'
end

Given(/^I use a simple standard proxy/) do
  step 'I set the environment variable "PROXY_TYPE" to "forwarding_proxy"'
end
