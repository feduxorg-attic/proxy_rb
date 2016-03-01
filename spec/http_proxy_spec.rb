# frozen_string_literal: true
require 'spec_helper'
require 'proxy_rb/http_proxy'

RSpec.describe HttpProxy do
  subject(:proxy) { described_class.new parser }

  let(:parser) { instance_double 'ProxyRb::ProxyUrlParser' }

  before :each do
    allow(parser).to receive(:proxy_url).and_return proxy_url
    allow(parser).to receive(:credentials).and_return credentials
  end

  let(:proxy_url) { double 'ProxyRb::ProxyUrl' }

  before :each do
    allow(proxy_url).to receive(:to_s).and_return 'http://localhost:3128'
    allow(proxy_url).to receive(:host).and_return 'localhost'
    allow(proxy_url).to receive(:port).and_return 3128
  end

  let(:credentials) { instance_double 'ProxyRb::Credentials' }

  before :each do
    allow(credentials).to receive(:to_s).and_return 'user1:*Test123'
    allow(credentials).to receive(:nil?).and_return false
    allow(credentials).to receive(:empty?).and_return false
    allow(credentials).to receive(:user_name).and_return 'user1'
  end

  describe '#to_ref' do
    let(:proxy_reference) do
      [
        proxy_url.host,
        proxy_url.port,
        credentials.user_name
      ].join('_').to_sym
    end

    it { expect(proxy.to_ref).to eq proxy_reference }
  end
end
