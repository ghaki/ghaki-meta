require 'ghaki/meta/dict/storage'
require File.join( File.dirname(__FILE__), 'dict_helper' )

module Ghaki module Meta module Dict module Storage_Test
describe Storage do
  include DictHelper

  before(:all) do
    setup_dict_names
  end

  before(:each) do
    @store = Storage.new
  end

  subject { @store }

  describe '#initialize' do
    it 'makes empty snake' do
      subject.snake.should be_empty
    end
    it 'makes empty camel' do
      subject.camel.should be_empty
    end
    it 'makes empty title' do
      subject.title.should be_empty
    end
  end

  it { should respond_to :snake }
  describe '#put_snake' do
    it 'stores value' do
      subject.put_snake @token, @snake
      subject.snake.has_key?(@token).should be_true
      subject.snake[@token].should == @snake
    end
  end
  describe '#get_snake' do
    it 'returns value when present' do
      subject.snake[@token] = @snake
      subject.get_snake(@token).should == @snake
    end
    it 'fails when missing' do
      lambda do
        subject.get_snake(@token)
      end.should raise_error(ArgumentError,"Unknown Token: #{@token}")
    end
  end

  it { should respond_to :title }
  describe '#put_title' do
    it 'stores value' do
      subject.put_title @token, @title
      subject.title.has_key?(@token).should be_true
      subject.title[@token].should == @title
    end
  end
  describe '#get_title' do
    it 'returns value when present' do
      subject.title[@token] = @title
      subject.get_title(@token).should == @title
    end
    it 'defaults when missing' do
      subject.snake[@token] = @snake
      subject.get_title(@token).should == @title
    end
  end

  it { should respond_to :camel }
  describe '#put_camel' do
    it 'stores value' do
      subject.put_camel @token, @camel
      subject.camel.has_key?(@token).should be_true
      subject.camel[@token].should == @camel
    end
  end
  describe '#get_camel' do
    it 'returns value when present' do
      subject.camel[@token] = @camel
      subject.get_camel(@token).should == @camel
    end
    it 'defaults when missing' do
      subject.snake[@token] = @snake
      subject.get_camel(@token).should == @camel
    end
  end

  describe '#opt_set' do
    it 'stores option when present' do
      subject.opt_set( { @token => @snake }, @token, 'ignore' )
      subject.get_snake(@token).should == @snake
    end
    it 'stores default when missing' do
      subject.opt_set( {}, @token, @snake )
      subject.get_snake(@token).should == @snake
    end
  end

  describe '#opt_plural' do
    it 'stores option when present' do
      subject.opt_plural( { @tokens => @snakes }, @tokens, :ignore )
      subject.get_snake(@tokens).should == @snakes
    end
    it 'stores default when missing' do
      subject.put_snake @token, @snake
      subject.opt_plural( {}, @tokens, @token )
      subject.get_snake(@tokens).should == @snakes
    end
  end

  describe '#opt_alias' do
    it 'stores option when present' do
      subject.put_snake @token, 'ignored'
      subject.opt_alias( { @aka => @snake }, @aka, @token )
      subject.get_snake(@aka).should == @snake
    end
    it 'stores default when missing' do
      subject.put_snake @token, @snake
      subject.opt_alias( {}, @aka, @token )
      subject.get_snake(@aka).should == @snake
    end
  end

  describe '#snake_to_title' do
    it 'translates snake case into title case' do
      subject.snake_to_title(@snake).should == @title
    end
  end

  describe '#title_to_camel' do
    it 'translates title case into camel case' do
      subject.title_to_camel(@title).should == @camel
    end
  end

  describe '#snake_to_camel' do
    it 'translates snake case into camel case' do
      subject.snake_to_camel(@snake).should == @camel
    end
  end

end
end end end end
