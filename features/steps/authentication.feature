Feature: Authenticate agains proxy

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Set directly via step
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the user "user1" with password "*Test123"
        And I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Set directly via step when password is missing, but environment variable is set
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the user "user1"
        And I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I set the environment variable "SECRET_USER1" to "*Test123"
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: <PASSWORD> is given in password string and environment variable is set
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://user1:<PASSWORD>@localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I set the environment variable "SECRET_USER1" to "*Test123"
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: <PASSWORD> is given in password string and vault knows about it
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://user1:<PASSWORD>@localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And a file named "features/support/proxy_rb.rb" with:
    """
    require 'proxy_rb/cucumber'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: <PASSWORD> is given in password string and one of the chained fetchers knows about it
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://user1:<PASSWORD>@localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And a file named "features/support/proxy_rb.rb" with:
    """
    require 'proxy_rb/cucumber'
    require 'proxy_rb/password_fetchers/environment_password_fetcher'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'proxy_rb/password_fetchers/chaining_password_fetcher'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::ChainingPasswordFetcher.new(
        [
          ProxyRb::PasswordFetchers::EnvironmentPasswordFetcher.new(prefix: 'SECRET'),
          ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
        ]
      )
    end
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I set the environment variable "SECRET_USER1" to "*Test123"
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass


  Scenario: <PASSWORD> is given in password string and no password can be retrieved
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://user1:<PASSWORD>@localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `cucumber`
    Then the features should not all pass with:
    """
    Failed to fetch password for username "user1"
    """
