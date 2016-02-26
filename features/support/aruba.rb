require 'aruba/cucumber'

Aruba.configure do |config|
  # config.exit_timeout                          = 120
  config.exit_timeout                          = 5
  config.io_wait_timeout                       = 2
  config.activate_announcer_on_command_failure = [:stderr, :stdout, :command]
end
