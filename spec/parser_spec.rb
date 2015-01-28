require 'spec_helper'

describe Jolly::Parser, '#describe' do
  it 'parses a describe statement' do
    Jolly::Parser.parse do
      describe 'get'
    end
  end

  it 'configures the described method' do
    config = Jolly::Parser.parse do
      describe 'get'
    end
    expect(config[:methods].keys).to eq(['get'])
  end

  it 'allows additional descriptions' do
    config = Jolly::Parser.parse do
      describe 'get'
      describe 'bar'
    end
    expect(config[:methods].keys).to eq(%w(get bar))
  end

  it 'disallows additional descriptions with the same name' do
    expect do
      Jolly::Parser.parse do
        describe 'get'
        describe 'get'
      end
    end.to raise_error(Jolly::Exceptions::InvalidName)
  end

  it 'configures a default description' do
    config = Jolly::Parser.parse do
      describe 'get'
    end
    expect(config[:methods]['get'][:description]).to eq('Method get')
  end

  it 'configures a custom description' do
    config = Jolly::Parser.parse do
      describe 'get', 'A method to access something'
    end
    expect(config[:methods]['get'][:description]).to eq('A method to access something')
  end
end

describe Jolly::Parser, '#parameters' do
  it 'parses a param statement' do
    Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer
    end
  end

  it 'disallows param statemens outside a description' do
    expect do
      Jolly::Parser.parse do
        param 'id', Integer
      end
    end.to raise_error(Jolly::Exceptions::InvalidFormat)
  end

  it 'configures the parameter name' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer
    end
    expect(config[:methods]['get'][:parameters].keys).to eq(['id'])
  end

  it 'configures the parameter type' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer
    end
    expect(config[:methods]['get'][:parameters]['id'][:type]).to eq(Integer)
  end

  it 'accepts the :required option' do
    Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, required: true
    end
  end

  it 'configures a condition for the required parameter' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, required: true
    end
    expect(config[:conditions]).to eq([condition: :exactly_one, parameters: ['id']])
  end

  it 'accepts the :multiple option' do
    Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true
    end
  end

  it 'configures the singular and plural parameter names' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true
    end
    expect(config[:methods]['get'][:parameters].keys).to include('id')
    expect(config[:methods]['get'][:parameters].keys).to include('ids')
  end

  it 'configures the singular and plural parameter types' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true
    end
    expect(config[:methods]['get'][:parameters]['id'][:type]).to eq(Integer)
    expect(config[:methods]['get'][:parameters]['ids'][:type]).to eq([Integer])
  end

  it 'configures the multiple property' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true
    end
    expect(config[:methods]['get'][:parameters]['id'][:multiple]).to eq('ids')
  end

  it 'configures a condition for multiple parameters' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true
    end
    expect(config[:conditions]).to eq([condition: :atmost_one, parameters: %w(id ids)])
  end

  it 'configures conditions for required multiple parameters' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer, multiple: true, required: true
    end
    expect(config[:conditions]).to eq([condition: :exactly_one, parameters: %w(id ids)])
  end

  it 'allows additional parameters' do
    config = Jolly::Parser.parse do
      describe 'get'
      param 'id', Integer
      param 'foo', String
    end
    expect(config[:methods]['get'][:parameters].keys).to eq(%w(id foo))
  end

  it 'disallows additional parameters with the same name' do
    expect do
      Jolly::Parser.parse do
        describe 'get'
        param 'id', Integer
        param 'id', String
      end
    end.to raise_error(Jolly::Exceptions::InvalidName)
  end
end
