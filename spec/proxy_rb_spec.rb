# frozen_string_literal: true
require 'spec_helper'

describe ProxyRb do
  describe 'Version number' do
    it { expect(ProxyRb::VERSION).not_to be nil }
  end
end
