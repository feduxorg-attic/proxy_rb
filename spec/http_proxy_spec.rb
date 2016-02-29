require 'spec_helper'
require 'proxy_rb/http_proxy'

RSpec.describe HttpProxy do
  subject(:proxy) { described_class.new parser }

  let(:parser) { instance_double 'ProxyRb::ProxyUrlParser' }

  before :each do
    allow(parser).to receive(:proxy_url).and_return proxy_url
    allow(parser).to receive(:credentials).and_return credentials
  end

  let(:proxy_url) { instance_double 'ProxyRb::ProxyUrl' }

  before :each do
    allow(proxy_url).to receive(:to_s).and_return 'http://localhost:3128'
    allow(proxy_url).to receive(:host).and_return 'localhost'
    allow(proxy_url).to receive(:port).and_return 3128
  end

  let(:credentials) { instance_double 'ProxyRb::Credentials' }

  before :each do
    allow(credentials).to receive(:to_s).and_return 'user1:password'
    allow(credentials).to receive(:nil?).and_return false
    allow(credentials).to receive(:empty?).and_return false
    allow(credentials).to receive(:user_name).and_return 'user1'
  end

  describe '#to_phantom_js' do
    let(:phantom_js_params) {
      [
        "--proxy=#{proxy_url}",
        "--proxy-auth=#{credentials}"
      ]
    }

    it { expect(proxy.to_phantom_js).to eq phantom_js_params }
  end

  describe '#to_sym' do
    let(:proxy_reference) {
      [
        proxy_url.host,
        proxy_url.port,
        credentials.user_name
      ].join('_').to_sym
    }

    it { expect(proxy.to_sym).to eq proxy_reference }
  end

end
