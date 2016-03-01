# frozen_string_literal: true
require 'spec_helper'
require 'proxy_rb/proxy_url'

RSpec.describe ProxyUrl do
  describe '.build' do
    subject(:proxy) { described_class.build(descriptor) }
    let(:descriptor) { { scheme: 'http', host: 'proxy', port: 8080 } }

    it { expect(proxy.to_s).to eq 'http://proxy:8080' }
    it { expect(proxy.port).to eq 8080 }
    it { expect(proxy.host).to eq 'proxy' }
  end

  describe '.parse' do
    subject(:proxy) { described_class.parse(descriptor) }

    context 'when valid url' do
      let(:descriptor) { 'http://proxy:8080' }

      it { expect(proxy.to_s).to eq 'http://proxy:8080' }
      it { expect(proxy.port).to eq 8080 }
      it { expect(proxy.host).to eq 'proxy' }
    end

    context 'when host:port' do
      let(:descriptor) { 'proxy:8080' }

      it { expect(proxy.to_s).to eq 'http://proxy:8080' }
      it { expect(proxy.port).to eq 8080 }
      it { expect(proxy.host).to eq 'proxy' }
    end

    context 'when host.domain:port' do
      let(:descriptor) { 'proxy.example.org:8080' }

      it { expect(proxy.to_s).to eq 'http://proxy.example.org:8080' }
      it { expect(proxy.port).to eq 8080 }
      it { expect(proxy.host).to eq 'proxy.example.org' }
    end

    context 'when user:*Test123@host.domain:port' do
      let(:descriptor) { 'http://user1:*Test123@proxy.example.org:8080' }

      it { expect(proxy.to_s).to eq 'http://user1:*Test123@proxy.example.org:8080' }
      it { expect(proxy.port).to eq 8080 }
      it { expect(proxy.host).to eq 'proxy.example.org' }
      it { expect(proxy.user).to eq 'user1' }
      it { expect(proxy.password).to eq '*Test123' }
    end

    context 'when empty string' do
      let(:descriptor) { '' }

      it { expect(proxy.to_s).to eq '' }
      it { expect(proxy.port).to eq nil }
      it { expect(proxy.host).to eq nil }
      it { expect(proxy.user).to eq nil }
      it { expect(proxy.password).to eq nil }
    end

    context 'when nil' do
      let(:descriptor) { nil }

      it { expect(proxy.to_s).to eq '' }
      it { expect(proxy.port).to eq nil }
      it { expect(proxy.host).to eq nil }
      it { expect(proxy.user).to eq nil }
      it { expect(proxy.password).to eq nil }
    end
  end

  describe '#empty?' do
    subject(:proxy) { described_class.parse(descriptor) }

    context 'when user:*Test123@host.domain:port' do
      let(:descriptor) { 'http://user1:*Test123@proxy.example.org:8080' }

      it { expect(proxy).not_to be_empty }
    end

    context 'when nil' do
      let(:descriptor) { nil }

      it { expect(proxy).to be_empty }
    end
  end
end
