# ProxyRb

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

### Rspec-Integration

```ruby
require 'proxy_rb/rspec'

RSpec.describe 'Infrastructure A' do
  describe 'proxy1' do
    subject { 'proxy1.example.com' }

    context 'request resource via http' do
      let(:resource) { Resource.new('http://example.com') }

      context 'when url is readable' do
        it { expect(proxy).to forward_url(resource) }
      end

      context 'when website needs to be browsed' do
        before(:each) { download(resource) }
        it { expect(resource).to have_content('Example') }
      end

      context 'when proxy authentication is needed' do
        let(:user) { ProxyUser.new(name: 'user1') }
        before(:each) { download(resource) }

        it { expect(resource).to have_content('Example') }
      end

      context 'when upload uses post http method' do
        let(:data) { 'data' }
        before(:each) { upload(resource, data) }

        it { expect(resource).to have_content('Example') }
      end

      context 'when upload uses put http method' do
        let(:data) { 'data' }
        before(:each) { upload(resource, data, method: 'put') }

        it { expect(resource).to have_content('Example') }
      end
    end

    context 'request resource via https' do
      let(:resource) { Resource.new('https://example.com') }
    end

    context 'request resource via ftp' do
      let(:resource) { Resource.new('ftp://example.com/file.txt') }

      context 'when website needs to be browsed' do
        before(:each) { download(resource) }
        it { expect(resource).to have_content('Example') }
      end

      context 'when url is readable' do
        it { expect(proxy).to forward_url(resource) }
      end

      context 'when authentication is needed' do
        let(:user) { ProxyUser.new(name: 'user1') }
        before(:each) { download(resource) }

        it { expect(resource).to have_content('Example') }
      end

      context 'when upload' do
        let(:data) { File.open('file.txt') }
        before(:each) { upload(resource, data) }

        it { expect(resource).to have_content('Example') }
      end
    end
  end
end
```

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

After checking out the repo, run `script/bootstrap` to install dependencies.
Then, run `script/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake gem:install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake gem:release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/proxy_rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
