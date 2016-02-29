Feature: Check for redirection by webserver/proxy

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple standard proxy

  Scenario: Simple HTTP request with proxy which is redirected with 301 status code
    Given I use a web server at "bin/http_server_1" with the following configuration:
         | option   | value                                                              |
         | Port     | 8008                                                               |
         | response | {"status": 301, "header": { "Location": "http://localhost:8000"} } |
    And I use a simple web server at "bin/http_server_2"
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_redirected }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server_1` in background
    And I run `http_server_2` in background
    When I run `rspec`
    Then the specs should all pass
