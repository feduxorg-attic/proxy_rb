# frozen_string_literal: true
require 'aruba/rspec'

Aruba.configure do |config|
  config.working_directory = 'tmp/rspec'
end
