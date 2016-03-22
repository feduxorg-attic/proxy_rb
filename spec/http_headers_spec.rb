require 'spec_helper'
require 'proxy_rb/http_headers'

RSpec.describe ProxyRb::HttpHeaders do
  subject(:http_headers) { described_class.new(capybara_headers) }

  let(:capybara_headers) { {} }

  describe '#to_h' do
    it { expect(http_headers.to_h).to be_empty }
    it { expect(http_headers.to_h).to eq({}) }

    context 'when contains HTTP_<header>' do
      let(:capybara_headers) do
        {
          'HTTP_X-My-Header' => 'my value'
        }
      end

      it { expect(http_headers.to_h['X-My-Header']).to eq('my value') }
    end

    context 'when contains non-HTTP_<header>' do
      let(:capybara_headers) do
        {
          'HTTP_X-My-Header' => 'my value',
          'Other-Header' => 'my value'
        }
      end

      it { expect(http_headers.to_h['X-My-Header']).to eq('my value') }
      it { expect(http_headers.to_h).not_to be_key('Other-Header') }
    end
  end
end
