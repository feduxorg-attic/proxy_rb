Feature: Check if request is forbidden

  As a proxy administrator
  I would like to check the mime type of a downloaded resource
  In order to verify that it's correct

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple proxy
    And I run `http_proxy` in background

  Scenario: If matches
    Given I use a web server with the following configuration:
       | option      | value | 
       | status_code | 403   | 
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

  Scenario: If does not match
    Given I use a simple web server
    And I run `http_server` in background
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
      context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).not_to be_forbidden }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: If it should match but fails it outputs a meaningful error message
    Given I use a simple web server
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
    Then the specs should not pass with:
    """
    expected that response of "http://localhost:8000" has status code 403, but has 200. No proxy was used.
    """

  Scenario: If it should not match but fails it outputs a meaningful error message
    Given I use a web server with the following configuration:
       | option      | value |
       | status_code | 403   |
    And I run `http_server` in background
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
      context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).not_to be_forbidden }
      end
    end
    """
    When I run `rspec`
    Then the specs should not pass with:
    """
    expected that response of "http://localhost:8000" does not have status code 403. No proxy was used.
    """

  Scenario: If it should not match but fails it outputs a meaningful error message even if a proxy is used
    Given I use a simple proxy
    And I use a web server with the following configuration:
       | option      | value |
       | status_code | 403   |
    And I run `http_server` in background
    And I run `http_proxy` in background
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://localhost:8080' }

      context 'With proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).not_to be_forbidden }
      end
    end
    """
    When I run `rspec`
    Then the specs should not pass with:
    """
    expected that response of "http://localhost:8000" does not have status code 403. It was fetched via proxy "http://localhost:8080".
    """

  Scenario: When server/proxy returns nil or zero as HTTP status code (strict mode)
    Given I use a web server with the following configuration:
       | option      | value |
       | status_code | 0   |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    ProxyRb.configure do |config|
      config.strict = true # default value, only set for demonstration purposes
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
        context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).not_to be_forbidden }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass


  Scenario: When server/proxy returns nil or zero as HTTP status code (non-strict mode)
    Given I use a web server with the following configuration:
       | option      | value |
       | status_code | 0   |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    ProxyRb.configure do |config|
      config.strict = false
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { NoProxy }
        context 'no proxy' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_forbidden }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
