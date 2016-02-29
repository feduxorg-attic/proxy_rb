require 'spec_helper'
require 'proxy_rb/resource'

RSpec.describe Resource do
  subject(:resource) { described_class.new url }
  let(:url) { 'http://example.com' }

  describe '#to_url' do
    it { expect(resource.to_url).to eq url }
  end

end
