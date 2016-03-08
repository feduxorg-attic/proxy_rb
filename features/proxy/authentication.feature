Feature: Authenticate against Proxy

  As a proxy administrator
  I normally use proxy servers which require authentication
  To let the users get access to the www

  Background:
    Given I use a fixture named "proxy-config"
    And I look for executables in "bin" within the current directory
    And I use a proxy requiring authentication
    And I use a simple web server
    And I run `http_proxy` in background
    And I run `http_server` in background
    And the following local users are authorized to use the proxy:
      | user  | password |
      | user1 | *Test123 |

  Scenario: Set authentication via subject (not recommended)

    This is the least secure option to set the password for authentication
    againts a proxy. It's not recommended to use this.

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user1:*Test123@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Use password from environment

    You can either set the environment variable with some script or you use
    [`dotenv`](https://github.com/bkeepers/dotenv) et al to set the variables.

    *Example: <project_root>/env.secrets.local*

    You can add the following snippet to your `spec/spec_helper.rb`-file to
    make `dotenv` load your secrets into the enviroment.

    ~~~ruby
    require 'dotenv'
    Dotenv.load File.expand_path('../../env.secrets.local', __FILE__)
    ~~~

    Now make sure, that you add this pattern to your `.gitignore`-file to make
    sure, the file is not part of the repository.

    ~~~ini
    env.secrets.local
    ~~~

    Given I set the environment variable "SECRET_USER1" to "*Test123"
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'uri'

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      let(:user_name) { 'user1' }
      subject { ProxyRb::ProxyUrl.build(host: 'localhost', port: 8080, user: user_name, password: password(user_name)) }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Use password from HashiCorp Vault
    Given I use a local vault server with the following data at "secret":
       | user  | password |
       | user1 | *Test123 |
    And a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/password_fetchers/vault_password_fetcher'
    require 'uri'

    ProxyRb.configure do |config|
      config.password_fetcher = ProxyRb::PasswordFetchers::VaultPasswordFetcher.new(prefix: 'secret')
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      let(:user_name) { 'user1' }
      subject { ProxyRb::ProxyUrl.build(host: 'localhost', port: 8080, user: user_name, password: password(user_name)) }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    When I successfully run `rspec`
    Then the specs should all pass

  Scenario: Use authentication with webkit driver
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/webkit_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::WebkitDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user1:*Test123@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use authentication with poltergeist driver
    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/poltergeist_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::PoltergeistDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user1:*Test123@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect(request).to be_successful }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use authentication with selenium driver

    This does not work unfortunately.

    Given a spec file named "test_spec.rb" with:
    """
    require 'spec_helper'
    require 'proxy_rb/drivers/selenium_driver'

    ProxyRb.configure do |config|
      config.driver = ProxyRb::Drivers::SeleniumDriver.new
    end

    RSpec.describe 'HTTP Proxy Infrastructure', type: :http_proxy do
      subject { 'http://user1:*Test123@localhost:8080' }

      context 'when working proxy chain' do
        before { visit 'http://localhost:8000' }

        it { expect { expect(response).to have_content 'Example' }.to raise_error Capybara::ElementNotFound }
      end
    end
    """
    And I run `http_proxy` in background
    And I run `http_server` in background
    When I run `rspec`
    Then the specs should all pass
