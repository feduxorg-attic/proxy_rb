Feature: Setup your project to use "proxy_rb"

  Background:
    Given I look for executables in "bin" within the current directory
    And I use a simple proxy
    And I use a simple web server
    And I run `http_proxy` in background
    And I run `http_server` in background

  Scenario: Setup project for "rspec"

    You may need to add `gem 'rspec'` to your `Gemfile`.

    Given a file named "spec/spec_helper.rb" with:
    """
    $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
    Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
    """
    And a file named "spec/support/proxy_rb.rb" with:
    """
    require 'proxy_rb/rspec'
    """
    And a file named "spec/test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(page).to have_content 'Example' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Setup project for "cucumber"

    You may need to add `gem 'cucumber'` to your `Gemfile`.

    Given a file named "features/support/proxy_rb.rb" with:
    """
    require 'proxy_rb/cucumber'
    """
    And a file named "features/result.feature" with:
    """
    Feature: Test the result code of a request
      Scenario: Request is allowed
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    When I successfully run `cucumber`
    Then the features should all pass
