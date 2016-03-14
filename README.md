# ProxyRb

[![Build Status](https://travis-ci.org/fedux-org/proxy_rb.png?branch=master)](https://travis-ci.org/fedux-org/proxy_rb)
[![Code Climate](https://codeclimate.com/github/fedux-org/proxy_rb.png)](https://codeclimate.com/github/fedux-org/proxy_rb)
[![Coverage Status](https://coveralls.io/repos/fedux-org/proxy_rb/badge.png?branch=master)](https://coveralls.io/r/fedux-org/proxy_rb?branch=master)
[![Gem Version](https://badge.fury.io/rb/proxy_rb.png)](http://badge.fury.io/rb/proxy_rb)
[![Downloads](http://img.shields.io/gem/dt/proxy_rb.svg?style=flat)](http://rubygems.org/gems/proxy_rb)

`proxy_rb` makes it easier for you to test your proxy infrastructre.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proxy_rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proxy_rb

## Usage

### Getting started

The following steps are only a suggestion. If you normally use a different
workflow, this is ok. Just make sure, that the `proxy_rb/rspec`-file is
required by `spec/spec_helper.rb` directly or indirectly.

*Initialize RSpec*

~~~bash
bundle exec rspec --init
~~~

*Modify "spec/spec_helper.rb"*

Add the following lines.

~~~ruby
# Loading support files
Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
~~~

*Load library*

Create a file named `spec/support/proxy_rb.rb`.

~~~ruby
require 'proxy_rb/rspec'
~~~

*Create first Tests* 

Create a file named `spec/test_spec.rb`.

~~~ruby
require 'spec_helper'

RSpec.describe 'My Proxy' do
  describe 'Production' do
    subject { 'http://localhost:8080' }

    before :each do
      visit 'http://example.com'
    end

    it { expect(request).to be_successful }
  end
end
~~~

Please have a look at the
["features/getting_started"](features/getting_started)-directory for more
information about that topic.

### Getting on with "proxy_rb"

Please have a look at our "feature"-files found [here](features/).

### Authentication

Maybe your proxy servers require authentication and you would like to test this
as well. You've got several possibilies to use proxy passwords with `proxy_rb`.
Please have a look at
["features/authentication.feature"](features/proxy/authentication.feature) for
detailed information.

### Driver

You can choose between three drivers to sent your requests: "Selenium", "Poltergeist" and
"Webkit". Please have a look at
["features/drivers"](features/drivers) for detailed
information.

## Development

### Requirements

Go to [the download site](https://www.vaultproject.io/downloads.html) of the
"Vault Project" and download the latest `vault` binary. Make sure you place it
into a path which is part of the "PATH"-environment variable - even on Windows.

*Example for a Linux Distribution*

~~~bash
curl -o /tmp/vault.zip https://releases.hashicorp.com/vault/0.5.1/vault_0.5.1_linux_amd64.zip
unzip /tmp/vault.zip
install -D /tmp/vault -m 0755 ~/bin/vault
~~~

Maybe you want to add the path `~/bin` to `PATH` via `.bashrc` or `.zshrc`.

~~~bash
export PATH=~/bin:$PATH
~~~

### Scripts

After checking out the repo, run `bin/bootstrap` to install dependencies.
Then, run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake gem:install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake gem:release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Caveats

* Authentication against a proxy using BASIC-scheme works fine for `Poltergeist` and `Webkit`-drivers. It fails for `Selenium` as you cannot pass username and password to the browser
* Authentication agains a proxy using NEGOTIATE (Kerberos) and NTLM-scheme fails for `Poltergeist` and `Webkit`-drivers due to problems with Qt which is used by both projects


