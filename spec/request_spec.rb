require 'spec_helper'
require 'proxy_rb/request'

RSpec.describe Request do
  subject(:request) { described_class.new page }
  let(:page) { double('Page') }

  before :each do
    allow(page).to receive(:status_code).and_return(status_code)
  end

  describe '#successful?' do
    context 'when status == 200' do
      let(:status_code) { 200 }

      it { expect(request).to be_successful }
    end

    context 'when status == 300' do
      let(:status_code) { 300 }

      it { expect(request).to be_successful }
    end

    context 'when status == 400' do
      let(:status_code) { 400 }

      it { expect(request).not_to be_successful }
    end
  end


end
