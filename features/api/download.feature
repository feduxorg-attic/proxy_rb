Feature: Download resources

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
        before { download 'http://localhost:8000' }

        it { expect(request).to be_successful }
        it { expect(response).to have_content 'Example' }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
