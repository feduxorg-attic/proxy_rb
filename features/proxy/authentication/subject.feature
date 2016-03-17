Feature: Authenticate against Proxy hardcoding the passwort in into the subject

  As a proxy administrator
  I normally use proxy servers which require authentication
  To let the users get access to the www

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a proxy requiring authentication
    And I use a simple web server
    And I run `http_proxy` in background
    And I run `http_server` in background
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |

  Scenario: Set authentication via subject (not recommended)

    This is the least secure option to set the password for authentication
    againts a proxy. It's not recommended to use this.

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user1:*Test123@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass
