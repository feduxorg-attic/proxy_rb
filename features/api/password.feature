Feature: Request Password from Password store

  Background:
    Given I use a fixture named "proxy-config"

  Scenario: Using passwords from environment variables
    Given I set the environment variable "SECRET_USER1" to "*Test123"
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

  Scenario: Using passwords from environment variables with different prefix
    Given I set the environment variable "NEW_SECRET_USER1" to "*Test123"
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'NEW_SECRET')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Using passwords from environment variables with "Dotenv"

    This example assumes, that you added `gem 'dotenv'`to your `Gemfile` (or
    something similar). It also assumes, that files in `spec/support` are
    loaded by `rspec` automatically. You need some code in your
    `spec/spec_helper.rb` to make this possible. Please have a look at the
    fixture used for this example at [fixtures](fixtures/proxy-config/).

    Given a file named ".env.secrets.local" with:
    """
    NEW_SECRET_USER1="*Test123"
    """
    And a file named "spec/support/dotenv.rb" with:
    """
    require 'dotenv'
    Dotenv.load(File.expand_path('../../../.env.secrets.local', __FILE__))
    """
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'NEW_SECRET')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      context 'when working proxy chain' do
        it { expect(password('user1')).to eq '*Test123' }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

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
