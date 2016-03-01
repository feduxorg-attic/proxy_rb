# frozen_string_literal: true
require 'spec_helper'
require 'proxy_rb/credentials'

RSpec.describe Credentials do
  subject(:credentials) { described_class.new(user_name, password) }
  let(:user_name) { 'user1' }
  let(:password) { '*Test123' }

  it { expect(credentials.user_name).to eq user_name }
  it { expect { credentials.password }.to raise_error NoMethodError }

  describe '#to_s' do
    it { expect(credentials.to_s).to eq format('%s:%s', user_name, password) }
  end

  describe '#empty?' do
    it { expect(credentials.empty?).not_to be true }

    context 'when user name is nil' do
      let(:user_name) { nil }

      it { expect(credentials.empty?).to be true }
    end

    context 'when password is nil' do
      let(:password) { nil }

      it { expect(credentials.empty?).to be true }
    end
  end
end
