require 'spec_helper'

describe Configus::Config do
  before do
    @options = {
      :foo => 'bar',
      :sections => {
        :first => 'first_value',
        :second => 'second_value',
        :another_key => {
          :key => :value
        }
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

  it 'should be transform to hash' do
    @config.to_hash.should == @options
  end

  it 'should passing each key-value pair' do
    @config.pairs.each_pair { |key, value| } == @options[:pairs].each_pair { |key, value| }
  end
end

describe "Hardcore" do

  it 'should use defined value' do
    p = Proc.new do
      env :production do
        foo 'bar'
        bar 'bom'
        baz -> { foo + bar }
      end
    end

    builder = Configus::Builder.new(:production, p)
    @options = builder.result
    @config = Configus::Config.new(@options)

    @config.foo == @options[:foo]
    @config.bar == @options[:bar]
    @config.baz == @options[:foo] + @options[:bar]
    @config.baz == @config.foo + @config.bar
  end

  it "second" do
    p = Proc.new do
      env :a do
        foo do
          bar 'baz'
          bom 'bim'
          baz -> { bar + bim}
        end
        key1 do
          key2 'value1'
          key3 'value2'
          key4 -> { key2 + key3}
        end
      end

      env :b, parent: :a do
        bom -> { foo.bar }
        key1 do
          key2 'value3'
        end
      end
    end

    builder_a = Configus::Builder.new(:a, p)
    @options_a = builder_a.result
    @config_a = Configus::Config.new(@options_a)

    builder_b = Configus::Builder.new(:b, p)
    @options_b = builder_b.result
    @config_b = Configus::Config.new(@options_b)

    @config_b.bom == @config_a.foo.bar
    @config_b.key1.key4 == @config_b.key1.key2 + @config_a.key1.key3
  end
end

