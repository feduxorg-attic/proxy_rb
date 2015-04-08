RSpec.shared_examples 'a loadable proxy.pac' do
  it { loader.load(proxy_pac) }
end

RSpec.shared_examples 'an un-readable proxy.pac' do
  before(:each) do
    expect(proxy_pac).to receive(:message=)
    expect(proxy_pac).to receive(:readable=).with(false)
    allow(proxy_pac).to receive(:content?).and_return(false)
  end

  it { loader.load(proxy_pac) }
end

RSpec.shared_examples 'a readable proxy.pac' do
  before :each do
    expect(proxy_pac).to receive(:content=).with(content.chomp)
    allow(proxy_pac).to receive(:content?).and_return(false)
  end

  before(:each) do
    expect(proxy_pac).not_to receive(:message=)
    expect(proxy_pac).to receive(:readable=).with(true)
  end

  it { loader.load(proxy_pac) }
end
