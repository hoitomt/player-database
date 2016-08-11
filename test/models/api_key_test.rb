require "test_helper"

describe ApiKey do
  let(:api_key){ build :api_key }

  it 'is valid' do
    api_key.must_be :valid?
  end
end
