Feature: Request Password from Hashi Corp Vault Password Store

  Background:
    Given I use a fixture named "proxy-config"

  Scenario: Using passwords from HashiCorp Vault
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: User name is upper case
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('USER1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: User name is lower case
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: User name as is
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | User1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('User1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: User name not found
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect{ password('other_user1') }.to raise_error ArgumentError }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass
