Feature: Test if access is forbidden

  As a proxy administrator
  I want to test a proxy
  In order to make sure, it's correctly configured

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Check if request is successful
    Given I use a simple web server
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
        context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Check if request is forbidden
    Given I use a web server with the following configuration:
      | option   | value            |
      | response | { "status": 403 } |
    And I run `http_server` in background
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
        context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_forbidden }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

