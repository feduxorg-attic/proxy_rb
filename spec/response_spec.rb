require 'spec_helper'
require 'proxy_rb/response'

RSpec.describe Response do
  subject(:response) { described_class.new page }
  let(:page) { double('Page') }

  before :each do
    allow(page).to receive(:status_code).and_return(status_code)
  end
end
