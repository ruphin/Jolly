require 'spec_helper'

describe Jolly::Parser, '#derp' do
  it 'parses a describe statement' do
    config = Jolly::Parser.parse do
      describe 'get'
    end
    expect(config[:methods].keys).to include('get')
  end
end
