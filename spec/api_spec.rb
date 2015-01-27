require 'spec_helper'

describe Jolly::API, '#derp' do
  it 'creates any necessary nested modules' do
    Jolly::API.create('TEST::API') {}
    expect(TEST).to be_a_kind_of(Module)
    expect(TEST::API).to be_a_kind_of(Module)
  end
end
