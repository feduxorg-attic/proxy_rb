Feature: Check mime type of downloaded resource

  As a proxy administrator
  I would like to check the mime type of a downloaded resource
  In order to verify that it's correct

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple proxy
    And I run `http_proxy` in background

  Scenario: Successful match
    Given I use a web server with the following configuration:
        | option  | value                         |
        | headers | {"Content-Type":"text/plain"} |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }

      before { visit 'http://localhost:8000' }

      it { expect(response).to have_mime_type 'text/plain' }
      it { expect(response).to be_of_mime_type 'text/plain' }
      it { expect(response).to have_mime_type starting_with('text/') }
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Invalid match
    Given I use a web server with the following configuration:
        | option  | value                         |
        | headers | {"Content-Type":"text/plain"} |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }

      before { visit 'http://localhost:8000' }

      it { expect(response).not_to have_mime_type 'image/png' }
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use "selenium" driver


    Given I use a web server with the following configuration:
        | option  | value                         |
        | headers | {"Content-Type":"text/plain"} |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/selenium_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::SeleniumDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }

      before { visit 'http://localhost:8000' }

      it { expect { expect(response).to have_mime_type 'text/plain' }.to raise_error Capybara::NotSupportedByDriverError }
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use "poltergeist" driver
    Given I use a web server with the following configuration:
        | option  | value                         |
        | headers | {"Content-Type":"text/plain"} |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/poltergeist_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::PoltergeistDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }

      before { visit 'http://localhost:8000' }

      it { expect(response).to have_mime_type 'text/plain' }
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use "webkit" driver
    Given I use a web server with the following configuration:
        | option  | value                         |
        | headers | {"Content-Type":"text/plain"} |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/webkit_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::WebkitDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }

      before { visit 'http://localhost:8000' }

      it { expect(response).to have_mime_type 'text/plain' }
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
