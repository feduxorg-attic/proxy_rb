Feature: Write tests to check request

  Background:
    Given I use a fixture named "proxy-config"

  Scenario: Using passwords from environment variables
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass
