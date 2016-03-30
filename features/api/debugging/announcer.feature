Feature: Announce information

  As a proxy administrator
  Writing my tests
  I would like to be able to troubleshoot my test suite

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple proxy
    And I use a simple web server

  Scenario: Output all information
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce: true do
      subject { 'http://user1:password1@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://user2:password2@localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Proxy: http://localhost:8080
    """
    And the output should contain:
    """
    Proxy User: user1:password1
    """
    And the output should contain:
    """
    Resource: http://user2:password2@localhost:8000
    """
    And the output should contain:
    """
    Resource User: user2:password2
    """
    And the output should contain:
    """
    <<-HTTP_RESPONSE_HEADERS
    """
    And the output should contain:
    """
    Server
    """
    And the output should contain:
    """
    HTTP Status Code: 200
    """

  Scenario: Output configured proxy without user name and password
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_proxy: true do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Proxy: http://localhost:8080
    """

  Scenario: Output configured proxy user name and password
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_proxy_user: true do
      subject { 'http://user1:password1@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Proxy User: user1:password1
    """

  Scenario: Output visited resource
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_resource: true do
      subject { 'http://localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://user1:password1@localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Resource: http://user1:password1@localhost:8000
    """

  Scenario: Output user name and password for visited resource
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_resource_user: true do
      subject { 'http://localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://user1:password1@localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Resource User: user1:password1
    """

  Scenario: Output HTTP Headers
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_http_response_headers: true do
      subject { 'http://localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    <<-HTTP_RESPONSE_HEADERS
    """
    And the output should contain:
    """
    Server
    """

  Scenario: Output HTTP status code
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy, announce_status_code: true do
      subject { 'http://localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    HTTP Status Code: 200
    """
