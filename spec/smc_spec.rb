require 'spec_helper'

describe Prnstn::SMC do
  it 'returns an array' do

    # TODO: extend fakeapi w/real data
    fakeapi = FakeAPI.new
    response = JSON.parse(fakeapi.fetch_mentions)

    expect(response).to be_an_instance_of(Array)
    expect(response.size).to be > 0

  end

  it 'returns a list of mentions' do

    stubbed_mentions  = [{"created_at": "Wed Dec 31 12:00:00 +0000 2016", "id": 123456789012345678, "text": "Message One"},{"created_at": "Wed Dec 31 12:00:00 +0000 2016","id": 123456789012345679,"id_str": "542352552063692800","text": "Message Two"}]

    # TODO

  end
end