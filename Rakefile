#!/usr/bin/env rake

# require 'bundler'
# Bundler.require :default, :test, :development

require 'coveralls/rake/task'
Coveralls::RakeTask.new

task default: :test

desc 'Run test suite'
# task test: %w(test:rubocop test:rspec test:cucumber)
task test: %w(test:cucumber)

namespace :test do
  desc 'Test with coveralls'
  task coveralls: %w(test coveralls:push)

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc 'Run rspec'
  task :rspec do
    sh 'bundle exec rspec'
  end

  desc 'Run cucumber'
  task :cucumber do
    sh 'bundle exec cucumber -p all'
  end
end
