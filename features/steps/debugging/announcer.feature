@experimental
Feature: Output information for debugging

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Announce all
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    Proxy: http://localhost:8080
    """

  Scenario: Announce proxy used
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    Proxy: http://localhost:8080
    """
    And the features should all pass with:
    """
    Proxy User: user1:\*Test123
    """
    And the features should all pass with:
    """
    Resource: http://localhost:8000
    """
    And the features should all pass with:
    """
    Resource User: user1:\*Test123
    """
    And the features should all pass with:
    """
    Server
    """
    And the features should all pass with:
    """
    HTTP Status Code: 200
    """

  Scenario: Announce proxy user used
    Given I use a proxy requiring authentication
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce-proxy-user
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://user1:*Test123@localhost:8080  |
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
    Then the features should all pass with:
    """
    Proxy User: user1:\*Test123
    """

  Scenario: Announce resource requested
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce-resource
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    Resource: http://localhost:8000
    """

  Scenario: Announce resource user requested
    Given I use a simple proxy
    And I use a web server requiring authentication
    And a file named "features/steps.feature" with:
    """
    @announce-resource-user
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://user1:*Test123@localhost:8000  |
    """
    And the following local users are authorized to use the web server:
      | user  | password |
      | user1 | *Test123 |
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    Resource User: user1:\*Test123
    """

  Scenario: Announce HTTP response headers
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce-http-response-headers
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    <<-HTTP_RESPONSE_HEADERS
    """
    And the output should contain:
    """
    Server
    """

  Scenario: Announce HTTP status code
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    @announce-status-code
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass with:
    """
    HTTP Status Code: 200
    """
