Feature: Aruba Console

  Background:
    Given a mocked home directory

  Scenario: Start console
    Given I run `proxy_rb console` interactively
    When I close the stdin stream
    Then the output should contain:
    """
    proxy_rb:001:0>
    """

  @unsupported-on-platform-java
  Scenario: Show help
    Given I run `proxy_rb console` interactively
    And I type "proxy_rb_help"
    When I close the stdin stream
    Then the output should contain:
    """
    Version:
    """
    And the output should contain:
    """
    Issue Tracker:
    """
    And the output should contain:
    """
    Documentation:
    """

  @unsupported-on-platform-java
  Scenario: Show methods
    Given I run `proxy_rb console` interactively
    And I type "proxy_rb_methods"
    When I close the stdin stream
    Then the output should contain:
    """
    Methods:
    """
    And the output should contain:
    """
    * visit
    """
    And the output should contain:
    """
    * download
    """
    And the output should contain:
    """
    * proxy
    """

  @unsupported-on-platform-java
  Scenario: Has history
    Given I run `proxy_rb console` interactively
    And I type "proxy_rb_methods"
    And I type "exit"
    When I close the stdin stream
    Then the file "~/.proxy_rb_history" should exist
