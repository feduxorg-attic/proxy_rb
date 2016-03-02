#!/usr/bin/env rake
# frozen_string_literal: true

namespace :gem do
  require 'bundler/gem_tasks'
end

# require 'bundler'
# Bundler.require :default, :test, :development

task default: :test

desc 'Run test suite'
task test: %w(test:rubocop test:rspec test:cucumber)

require 'coveralls/rake/task'
Coveralls::RakeTask.new

desc 'Test with coveralls'
task coveralls: %w(test coveralls:push)

namespace :test do
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
