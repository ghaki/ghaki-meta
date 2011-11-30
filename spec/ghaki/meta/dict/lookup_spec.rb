require 'ghaki/meta/dict/lookup'

require File.join( File.dirname(__FILE__), 'dict_helper' )

module Ghaki module Meta module Dict module Lookup_Test
describe Lookup do
  include DictHelper

  before(:all) do
    setup_dict_names
  end

  before(:each) do
    @lookup = Lookup.new @token
  end

  subject { @lookup }

  describe '#initialize' do
    it 'accepts option :dict_storage' do
      @storage = Storage.new
      @lookup = Lookup.new( @token, :dict_storage => @storage )
      subject.storage.should == @storage
    end
  end

  describe '#snake' do
    it 'get snake value' do
      subject.storage.put_snake @token, @snake
      subject.snake.should == @snake
    end
  end
  describe '#snake=' do
    it 'put snake value' do
      subject.snake = @snake
      subject.storage.get_snake(@token).should == @snake
    end
  end

  describe '#camel' do
    it 'get camel value' do
      subject.storage.put_camel @token, @camel
      subject.camel.should == @camel
    end
  end
  describe '#camel=' do
    it 'put camel value' do
      subject.camel = @camel
      subject.storage.get_camel(@token).should == @camel
    end
  end

  describe '#title' do
    it 'get title value' do
      subject.storage.put_title @token, @title
      subject.title.should == @title
    end
  end
  describe '#title=' do
    it 'put title value' do
      subject.title = @title
      subject.storage.get_title(@token).should == @title
    end
  end

  describe '#opt_set' do
    it 'delegates option setting' do
      @opts = { :bogus => 'fake' }
      subject.storage.expects(:opt_set).
        with(@opts,@token,@snake).once
      subject.opt_set @opts, @snake
    end
  end

  describe '#opt_plural' do
    it 'delegates option setting' do
      @opts = { :bogus => 'fake' }
      subject.storage.expects(:opt_plural).
        with(@opts,@token,@tokens).once
      subject.opt_plural @opts, @tokens
    end
  end

  describe '#opt_alias' do
    it 'delegates option setting' do
      @opts = { :bogus => 'fake' }
      subject.storage.expects(:opt_alias).
        with(@opts,@token,@aka).once
      subject.opt_alias @opts, @aka
    end
  end

end
end end end end
