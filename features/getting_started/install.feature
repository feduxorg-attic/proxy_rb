Feature: Getting Started with "proxy_rb"

  As a proxy administrator
  I would like to have a tool to test the proxy systems I'm responsible for
  In order to make sure they are configured correctly

  Scenario: Install "proxy_rb" via Rubygems
    Given the default aruba exit timeout is 60 seconds
    Given I successfully run `gem install proxy_rb`
    Then the "proxy_rb"-gem should be installed on the local system
