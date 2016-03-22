Feature: Format input as simple table

  As a proxy administrator
  I want to output a Hash as simple table
  In order to debug my setup or check something

  Background:
    Given I use a fixture named "proxy-config"

  Scenario: Valid hash
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Api', type: :http_proxy do
      describe '#simple_table' do
        subject { simple_table(input) }

        let(:input) do
          {
            key2: 'value',
            key1: 'value'
          }
        end

        let(:output) { ['# key1 => value', '# key2 => value'].join("\n") }

        it { is_expected.to eq output }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
