Feature: Check the result of a requests

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Allowed requests
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
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
    Then the features should all pass

  Scenario: Forbidden requests
    Given I use a simple proxy
    And I use a web server with the following configuration:
       | option      | value | 
       | status_code | 403   | 
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Steps
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        Then the following requests are not allowed to pass the proxy:
          | url                    |
          | http://localhost:8000  |
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass
