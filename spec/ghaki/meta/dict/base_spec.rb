require 'ghaki/meta/dict/base'
require File.join( File.dirname(__FILE__), 'dict_helper' )

module Ghaki module Meta module Dict module Base_Test
describe Base do
  include DictHelper

  class Mine < Dict::Base
    dict_lookup_rule :quack, :quacks
  end

  before(:all) do
    setup_dict_names
  end

  before(:each) do
    @dict = Mine.new
  end
  subject { @dict }

  it 'makes dict rules' do
    should respond_to :quack
    should respond_to :quacks
  end

  it 'allows get and set' do
    subject.quack.snake = @snake
    subject.quack.to_s.should == @snake
    subject.quack.title.should == @title
    subject.quack.snake.should == @snake
    subject.quack.camel.should == @camel
  end

  context 'using :opt_set' do
    subject { @dict.quack }
    it 'accepts option' do
      @dict.quack.opt_set( { @token => @snake }, 'ignore' )
      subject.snake.should == @snake
    end
    it 'defaults value' do
      @dict.quack.opt_set( {:ignore => 'bogus'}, @snake )
      subject.snake.should == @snake
    end
  end

  context 'using :opt_plural' do
    before(:each) do
      @dict.quack.snake = @snake
    end
    subject { @dict.quacks }
    it 'accepts option' do
      subject.opt_plural( { @tokens => @snakes}, :ignore )
      subject.snake.should == @snakes
    end
    it 'defaults value' do
      subject.opt_plural( { :ignore => 'bogus' }, @token )
      subject.snake.should == @snakes
    end
  end

end
end end end end
