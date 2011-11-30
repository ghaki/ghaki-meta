require 'ghaki/meta/builder'

module Ghaki module Meta module Builder_Testing

  # SUPPORT OBJECTS
  class UsingImport
    include Ghaki::Meta::Builder
  end
  class UsingAttr < UsingImport
    attr_meta_builder :child
  end

  class Helper
    attr_accessor :word
    def initialize word
      @word = word
    end
  end
  class Child < Helper; end
  class Parent < Helper; end

  class UsingSetup < UsingAttr
    set_meta_builder :child => Child, :parent => Parent
    def initialize
      setup_meta_builders 'together'
    end
  end
  class UsingMake < UsingAttr
    set_meta_builder :child => Child, :parent => Parent
    def initialize
      make_meta_builder :child, 'first'
      make_meta_builder :parent, 'second'
    end
  end

  class Worm < Helper ; end
  class UsingWorm < Helper
    attr_accessor :dinner
  end
  class Bird < UsingWorm; end
  class Fish < UsingWorm; end
  class Vole < UsingWorm; end

  class ChainA < UsingImport
    attr_meta_builder :worm
    def initialize 
      setup_meta_builders 'together'
      setup_dinner
    end
    def setup_dinner
    end
  end
  class ChainB < ChainA
    attr_meta_builder :fish, :bird
    def setup_dinner; super
      @fish.dinner = @bird.dinner = @worm
    end
  end
  class ChainC < ChainB
    attr_meta_builder :vole
    def setup_dinner; super
      @vole.dinner = @worm
    end
  end
  class ChainD < ChainC
    set_meta_builder \
      :worm => Worm,
      :bird => Bird, :fish => Fish,
      :vole => Vole
  end

  class Toy ; end
  class ToyFactory
    private_class_method :new
    def self.create
      Toy.new
    end
  end
  class UsingFactory < UsingImport
    set_meta_builder :toy => ToyFactory
    def initialize
      setup_meta_builders
    end
  end

# ACTUAL TESTING
describe Ghaki::Meta::Builder do

  describe 'when importing' do
    context 'meta' do
      subject { UsingImport }
      it { should respond_to :attr_meta_builder }
      it { should respond_to :set_meta_builder }
      it { should respond_to :meta_builders }
    end
    context 'object' do
      subject { UsingImport.new }
      it { should respond_to :setup_meta_builders }
      it { should respond_to :make_meta_builder }
    end
  end

  describe 'when calling #attr_meta_builder for child helper' do
    context '#meta_builders' do
      subject { UsingAttr }
      it 'should have placeholder' do
        subject.meta_builders.has_key?(:child).should be_true
        subject.meta_builders[:child].should be_nil
      end
    end
    context 'object' do
      subject { UsingAttr.new }
      it { should respond_to :child }
      it { should respond_to :child= }
    end
  end

  describe 'when calling #set_meta_builder for parent helper' do
    context '#meta_builders' do
      subject { UsingSetup }
      it 'should have class for parent helper' do
        subject.meta_builders[:child].should == Child
      end
      it 'should have class for child helper' do
        subject.meta_builders[:parent].should == Parent
      end
    end
    context 'object' do
      subject { UsingSetup.new }
      it { should respond_to :parent }
      it { should respond_to :parent= }
    end
  end

  shared_examples_for 'class creations' do
    it 'should create parent helper' do
      subject.child.should be_an_instance_of(Child)
    end
    it 'should create child helper' do
      subject.parent.should be_an_instance_of(Parent)
    end
  end

  describe 'when using #make_meta_builder' do
    subject { UsingMake.new }
    it_should_behave_like 'class creations'
    it 'should set specific args for parent helper' do
      subject.child.word.should == 'first'
    end
    it 'should set specific args for child helper' do
      subject.parent.word.should == 'second'
    end
  end

  describe 'when using #setup_meta_builders' do
    subject { UsingSetup.new }
    it_should_behave_like 'class creations'
    it 'should set common args for parent helper' do
      subject.child.word.should == 'together'
    end
    it 'should set common args for child helper' do
      subject.parent.word.should == 'together'
    end
  end

  describe 'when using factory class' do
    subject { UsingFactory.new }
    it 'should create object' do
      subject.toy.should_not be_nil
    end
  end

  describe 'when using chained inheritence' do

    context '#meta_builders' do
      subject { ChainD }
      it 'should have full heirarchy of classes' do
        subject.meta_builders.length.should == 4
      end
      it 'should set up worm' do
        subject.meta_builders[:worm].should == Worm
      end
      it 'should set up bird' do
        subject.meta_builders[:bird].should == Bird
      end
      it 'should set up fish' do
        subject.meta_builders[:fish].should == Fish
      end
      it 'should set up vole' do
        subject.meta_builders[:vole].should == Vole
      end
    end

    context 'object' do
      subject { ChainD.new }
      it 'should have worm' do
        subject.worm.class == Worm
      end
      it 'should have bird' do
        subject.bird.class == Bird
      end
      it 'should have fish' do
        subject.fish.class == Fish
      end
      it 'should have vole' do
        subject.vole.class == Vole
      end
      it 'should set dinner for bird' do
        subject.bird.dinner.should == subject.worm
      end
      it 'should set dinner for fish' do
        subject.fish.dinner.should == subject.worm
      end
      it 'should set dinner for vole' do
        subject.vole.dinner.should == subject.worm
      end
    end

  end

end
end end end
