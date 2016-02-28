require 'simplecov'

SimpleCov.command_name 'cucumber'
SimpleCov.start

require 'pry'
require 'byebug'

# Pull in all of the gems including those in the `test` group
# require 'bundler'
# Bundler.require :default, :test, :development

ENV['TEST'] = 'true'

# Loading support files
Dir.glob(::File.expand_path('../../../test/support/*.rb', __FILE__)).each { |f| require_relative f }
Dir.glob(::File.expand_path('../../../test/support/**/*.rb', __FILE__)).each { |f| require_relative f }
