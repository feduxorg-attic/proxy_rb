Feature: Test if access is forbidden

  As a proxy administrator
  I want to test a proxy
  In order to make sure, it's correctly configured

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Simple HTTP request with proxy which is forbidden with 403
    Given I use a simple proxy
    And I use a web server at "bin/http_server" with the following configuration:
       | option      | value | 
       | status_code | 403   | 
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_forbidden }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
