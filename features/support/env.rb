require 'simplecov'

SimpleCov.command_name 'cucumber'
SimpleCov.start

require 'pry'
require 'byebug'

# Pull in all of the gems including those in the `test` group
# require 'bundler'
# Bundler.require :default, :test, :development

ENV['TEST'] = 'true'
