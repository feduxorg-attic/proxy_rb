Feature: Check the content of a requested page

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Has content
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Use response
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit "http://localhost:8000"
        Then the last response should contain:
        \"\"\"
        Example
        \"\"\"
      Scenario: Use page
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit "http://localhost:8000"
        Then the last requested page should contain:
        \"\"\"
        Example
        \"\"\"
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Doesn't have content
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Use response
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit "http://localhost:8000"
        Then the last response should not contain:
        \"\"\"
        Whooray
        \"\"\"
      Scenario: Use page
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit "http://localhost:8000"
        Then the last requested page should not contain:
        \"\"\"
        Whooray
        \"\"\"
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Multiple sites have content
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Use response
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit the following websites:
          | url                   |
          | http://localhost:8000 |
          | http://localhost:8000 |
        Then all responses should contain:
        \"\"\"
        Example
        \"\"\"
      Scenario: Use page
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit the following websites:
          | url                   |
          | http://localhost:8000 |
          | http://localhost:8000 |
        Then all requested pages should contain:
        \"\"\"
        Example
        \"\"\"
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Multiple sites not have content
    Given I use a simple proxy
    And I use a simple web server
    And a file named "features/steps.feature" with:
    """
    Feature: Steps
      Scenario: Use response
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit the following websites:
          | url                   |
          | http://localhost:8000 |
          | http://localhost:8000 |
        Then all responses should not contain:
        \"\"\"
        Whooray
        \"\"\"
      Scenario: Use page
        Given I use the following proxies:
          | proxy                  |
          | http://localhost:8080  |
        When I visit the following websites:
          | url                   |
          | http://localhost:8000 |
          | http://localhost:8000 |
        Then all requested pages should not contain:
        \"\"\"
        Whooray
        \"\"\"
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I successfully run `cucumber`
    Then the features should all pass

