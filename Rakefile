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
  task :rubocop do
    sh 'rubocop'
  end

  desc 'Run rspec'
  task :rspec do
    sh 'bundle exec rspec'
  end

  desc 'Run cucumber'
  task :cucumber do
    sh 'bundle exec cucumber'
  end
end

desc 'Remove files in tmp'
task :clobber do
  rm_rf Dir.glob(File.expand_path('../tmp/*', __FILE__))
end
