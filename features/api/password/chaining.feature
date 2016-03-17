Feature: Request Password from Chained Password Stores

  Background:
    Given I use a fixture named "proxy-config"

  Scenario: Using passwords from chained password fetchers
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'proxy_rb/password_fetchers/environment_password_fetcher'
    require 'proxy_rb/password_fetchers/chaining_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::ChainingPasswordFetcher.new(
        [
          ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'SECRET'),
          ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
        ]
      )
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Using passwords from chained password fetchers where both can resolve user name

    The first one configured wins.

    Given I set the environment variable "SECRET_USER1" to "*Test123"
    And I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | 123Test* |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'proxy_rb/password_fetchers/environment_password_fetcher'
    require 'proxy_rb/password_fetchers/chaining_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::ChainingPasswordFetcher.new(
        [
          ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'SECRET'),
          ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
        ]
      )
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: None can fetch password for user name
    Given I run `vault server -dev` in background
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'proxy_rb/password_fetchers/environment_password_fetcher'
    require 'proxy_rb/password_fetchers/chaining_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::ChainingPasswordFetcher.new(
        [
          ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'SECRET'),
          ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
        ]
      )
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect{ password('user1') }.to raise_error ArgumentError }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass
