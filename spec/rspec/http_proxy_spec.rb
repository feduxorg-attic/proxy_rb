require 'spec_helper'
require 'proxy_rb/rspec'

RSpec.describe 'HTTP proxy', type: :http_proxy do
  describe 'proxy1' do
    # subject { 'proxy1.example.com:8080' }
    subject { 'localhost:3128' }

    # before :each do
    #   stub_request(:get, 'http://example.com/').to_return(status: 200, body: 'Example Domain', :headers => {})
    # end

    context 'download data from site' do
      let(:resource) { 'http://example.com' }
      before(:each) { download(resource) }

      it { expect(page).to have_content('Example Domain') }
    end
  end
end
