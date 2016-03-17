Feature: Authenticate against Proxy using HashiCorp Vault

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

  Scenario: Password can be found in vault
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'uri'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      let(:user_name) { 'user1' }
      subject { ProxyRb::ProxyUrl.build(host: 'localhost', port: 8080, user: user_name, password: password(user_name)) }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass
