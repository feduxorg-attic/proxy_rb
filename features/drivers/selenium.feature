Feature: Choose selenium driver to sent requests to proxy

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a simple standard proxy
    And I use a simple web server

  Scenario: Successful request
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/selenium_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::SeleniumDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(page).to have_content 'Example' }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Proxy is not reachable
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/selenium_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::SeleniumDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(page).to raise_error Capybara::ElementNotFound }
      end
    end
    """
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Web Server is not reachable
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/selenium_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::SeleniumDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'localhost:8080' }
      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(page).to have_content 'Service Unavailable' }
      end
    end
    """
    And I run `http_proxy` in background
    When I run `rspec`
    Then the specs should all pass
