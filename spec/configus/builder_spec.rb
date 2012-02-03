require 'spec_helper'

describe Configus::Builder do
  before do
    p = Proc.new do
      env :production do
        key 'value'
        foo 'bar'
        sections do
          first 'first_value'
          second 'second_value'
        end
      end

      env :development, :parent => :production do
        bar 'foo'
        foo 'foobar'
        nil_value nil
        false_value false
        sections do
          first 'another_value'
        end
      end
    end
    builder = Configus::Builder.new(:development, p)
    @options = builder.result
  end

  it 'should be generate correct hash' do
    @options.should == {
      :key => 'value',
      :bar => 'foo',
      :foo => 'foobar',
      :nil_value => nil,
      :false_value => false,
      :sections => {
        :first => 'another_value',
        :second => 'second_value'
      }
    }
  end
end
