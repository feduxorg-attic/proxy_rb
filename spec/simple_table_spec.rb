require 'spec_helper'
require 'proxy_rb/simple_table'

RSpec.describe ProxyRb::SimpleTable do
  subject(:table) { described_class.new(hash, options) }
  let(:options) { {} }

  context 'when valid hash' do
    let(:hash) do
      {
        :key1 => 'value',
        :key2 => 'value'
      }
    end
    let(:rows) { ['# key1 => value', '# key2 => value'] }

    it { expect(table.to_s).to eq rows.join("\n") }
  end

  context 'when empty hash' do
    let(:hash) { {} }
    let(:rows) { [] }

    it { expect(table.to_s).to eq rows.join("\n") }
  end

  context 'when nil' do
    let(:hash) { nil }
    let(:rows) { [] }

    it { expect(table.to_s).to eq rows.join("\n") }
  end

  context 'when unsorted values' do
    context 'when using defaults' do
      let(:hash) do
        {
          :key2 => 'value',
          :key1 => 'value'
        }
      end

      let(:rows) { ['# key1 => value', '# key2 => value'] }

      it { expect(table.to_s).to eq rows.join("\n") }
    end

    context 'when setting option :sort => false' do
      let(:options) do
        {
          sort: false
        }
      end

      let(:hash) do
        {
          :key2 => 'value',
          :key1 => 'value'
        }
      end

      let(:rows) { ['# key2 => value', '# key1 => value'] }

      it { expect(table.to_s).to eq rows.join("\n") }
    end
  end
end
