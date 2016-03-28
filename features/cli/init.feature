Feature: Initialize project with "proxy_rb"

  To add `proxy_rb` to your project you can use the `proxy_rb init`-command.

  Background:
    Given I use the fixture "empty"

  Scenario: Create files for RSpec (default)
    When I successfully run `proxy_rb init`
    Then the following files should exist:
      | spec/spec_helper.rb |
    And the file "spec/support/proxy_rb.rb" should contain:
    """
    require 'proxy_rb/rspec'
    """
    And the file "Gemfile" should contain:
    """
    gem 'proxy_rb'
    """
    When I successfully run `rspec`
    Then the output should contain:
    """
    0 examples, 0 failures
    """

  Scenario: Create files for RSpec
    When I successfully run `proxy_rb init --test-framework rspec`
    Then the following files should exist:
      | spec/spec_helper.rb |
    And the file "spec/support/proxy_rb.rb" should contain:
    """
    require 'proxy_rb/rspec'
    """
    And the file "Gemfile" should contain:
    """
    gem 'proxy_rb'
    """
    When I successfully run `rspec`
    Then the output should contain:
    """
    0 examples, 0 failures
    """

  Scenario: Create files for Cucumber
    When I successfully run `proxy_rb init --test-framework cucumber`
    And the file "features/support/proxy_rb.rb" should contain:
    """
    require 'proxy_rb/cucumber'
    """
    And the file "Gemfile" should contain:
    """
    gem 'proxy_rb'
    """
    When I successfully run `rspec`
    Then the output should contain:
    """
    0 examples, 0 failures
    """

  Scenario: Unknown Test Framework
    When I run `proxy_rb init --test-framework unknown`
    Then the output should contain:
    """
    got unknown
    """
