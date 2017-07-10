require_relative '../parse'

describe 'Parseing' do
  it 'should parse' do
    time = timestamp '1:1:1.123'
    expect(time).to eq 3_661_123
  end
end
