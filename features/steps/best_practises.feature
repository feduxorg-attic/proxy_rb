Feature: Best practises for using the steps

  As a proxy adminstrator
  I want to describe the use cases my proxy servers can handle
  In order make them work as the users expected them to work and I follow best
  practises and don't use to specific steps.

  If one needs to define a use case, it's best to use words/terms your product
  owners/managers know about. The steps defined in `proxy_rb` are quite
  technical and normally not suitable for describing use cases. BUT they are
  quite handy to use them as low level steps you're calling from your own
  ones.

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory

  Scenario: Blocking access to virus infected sites

    This example is about blocking virus found by a virus scanner attached to a
    proxy server. It demonstrate the use of the low level steps provided by
    `proxy_rb`.

    Given I use a virus blocking proxy requiring authentication
    And I use a virus infected web server
    And a feature file named "best_practises.feature" with:
    """
    @site-production
    Feature: Blocking access to virus infected sites
      Scenario: Virus was found
        Given a normal user
        When the user tries to access a virus infected site
        Then all requests to those virus infected sites should be blocked
    """
    And a file named "features/step_definitions.rb" with:
    """
    Before '@site-production' do
      t =  table(
      <<~EOS
         | proxy                 | 
         | http://localhost:8080 | 
      EOS
      )

      step 'I use the following proxies:', t
    end

    Given(/a normal user/) do
      step 'I use the user "user1" with password "*Test123"'
    end

    When(/the user tries to access a virus infected site/) do
      t =  table(
      <<~EOS
         | url                                          | 
         | http://localhost:8000/download/eicar.com     | 
         | http://localhost:8000/download/eicar.com.txt | 
         | http://localhost:8000/download/eicar_com.zip | 
      EOS
      )

      step 'I visit the following websites:', t
    end

    Then(/all requests to those virus infected sites should be blocked/) do
      step 'all responses should contain:', 'Virus found!'
    end
    """
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `cucumber`
    Then the features should all pass
