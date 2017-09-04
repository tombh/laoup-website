require_relative '../lib/parse_subs'
require_relative '../lib/aggregate'

describe 'Parsing' do
  it 'should parse' do
    time = ParseSubs.timestamp '1:1:1.123'
    expect(time).to eq 3_661_123
  end
end

describe 'Files' do
  it 'should extract the date from a filename' do
    stub_const(
      'Aggregate::VTT_PATH_PATTERN',
      'spec/*.vtt'
    )
    aggregator = Aggregate.new
    aggregator.compile_all
    encounter = aggregator.all[:japanese][:encounters][0]
    expect(encounter[:video_id]).to eq 'id123'
    expect(encounter[:title]).to eq 'thetitle'
    expect(encounter[:start]).to eq 150
    expect(encounter[:date]).to eq '2017-08-04'
    expect(encounter[:duration]).to eq 4
    expect(encounter[:opener]).to eq 'Hi'
  end
end
