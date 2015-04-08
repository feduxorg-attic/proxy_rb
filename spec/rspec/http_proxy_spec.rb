require 'spec_helper'
require 'proxy_rb/rspec'

RSpec.describe 'HTTP proxy' do
  describe 'proxy1' do
    subject { 'proxy1.example.com' }

    context 'download data from site' do
      let(:resource) { 'http://example.com' }
      before(:each) { download(resource) }

      expect(page).to have_content('Example Domain')
    end
  end
end
