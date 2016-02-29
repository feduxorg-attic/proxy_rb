Feature: Test Proxy

  As a proxy administrator
  I want to test a proxy
  In order to make sure, it's correctly configured

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple standard proxy
    And I use a simple web server

  Scenario: Simple HTTP request with proxy
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
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

  Scenario: Proxy given as HTTP-url
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
    subject { 'http://localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }
        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Has valid content
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(page).to have_content /Example/ }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

    @broken
  Scenario: Redirected HTTP request
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_redirected_to 'http://example.org' }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `rspec`
    Then the specs should all pass


  @broken

  Scenario: Simple HTTP request with missing proxy port
    Without a port given, port 8080 is used

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
    subject { 'http://localhost' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }
        it { expect(response).to be_success }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `rspec`
    Then the specs should all pass

    @broken
  Scenario: Forbidden HTTP response with missing proxy port
    Without a port given, port 8080 is used

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
    subject { 'http://localhost' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }
        it { expect(response).to be_forbidden }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `rspec`
    Then the specs should all pass

    @broken
  Scenario: Forbidden HTTP request with missing proxy port
    Without a port given, port 8080 is used

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
    subject { 'http://localhost' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }
        it { expect(request).to be_forbidden }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Simple HTTP request without proxy
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when nil given' do
        subject { nil }
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end

      context 'when no proxy given' do
        subject { NoProxy }

        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
