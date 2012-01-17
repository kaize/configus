require 'spec_helper'

describe Configus::Config do
  before do
    @options = {
      :foo => 'bar',
      :sections => {
        :first => 'first_value',
        :second => 'second_value'
      },
      :pairs => { :pkay => "vkay" }
    }
    @config = Configus::Config.new(@options)
  end

  it 'should be defined' do
    @config.foo == @options[:foo]
    @config.sections.first == @options[:sections][:first]
  end

  it 'should be raise' do
    lambda {@config.dont_exists}.should raise_error(RuntimeError)
  end

  it 'should be available as hash' do
    @config[:foo] == @options[:foo]
    @config[:sections].second == @options[:sections][:second]
  end

  it 'should passing each key-value pair' do
    @config.pairs.each_pair { |key, value| } == @options[:pairs].each_pair { |key, value| }
  end
end

