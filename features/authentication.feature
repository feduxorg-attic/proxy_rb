Feature: Authenticate agains proxy

  As a proxy administrator
  I normally use proxy serververs which require authentication
  To let the users get access to the www

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a proxy requiring authentication

  Scenario: Set authentication via subject
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user:password@localhost:8080' }

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

  Scenario: Use password from environment
    Given I use a proxy requiring authentication
    And I set the environment variable "PASSWORD_USER1" to "*Test123"
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      let(:user_name) { 'user1' }
      subject { format('http://%s:%s@localhost:8080', user_name, fetch_password(user_name)) }

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

  Scenario: Use password from HashiCorp Vault
    Given I use a proxy requiring authentication
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetcher/vault'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetcher::Vault.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      let(:user_name) { 'user' }
      subject { format('http://%s:%s@localhost:8080', user_name, fetch_password(user_name)) }

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
