module Ghaki #:nodoc:
module Meta  #:nodoc:

# Allow meta classes to be specified for later creation.
module Builder

  # Generate meta objects using builders.
  def setup_meta_builders *args
    self.class.meta_builders.each_key do |token|
      make_meta_builder token, *args
    end
  end

  # Make meta object using builder.
  def make_meta_builder token, *args
    klass = self.class.meta_builders[token]
    raise NotImplementedError, "Meta Builder Not Set: #{token}" if klass.nil?
    obj = if klass.respond_to?(:new)
            klass.new( *args )
          elsif klass.respond_to?(:create)
            klass.create( *args )
          else
            raise NotImplementedError, "Unknown Builder For Class: #{klass}"
          end
    self.send( (token.to_s + '=').to_sym, obj )
  end

  ######################################################################
  module ClassMethods

    # Getter for the meta builder helper object.
    def meta_builders
      @meta_builders ||= {}
    end

    # Declare meta builder attributes.
    def attr_meta_builder *tokens
      @meta_builders ||= {}
      tokens.each do |token|
        @meta_builders[token] = nil
        module_eval <<-"END"
          def #{token}      ; @#{token}       end
          def #{token}= val ; @#{token} = val end
        END
      end
    end

    # Assign classes to meta builder attributes.
    def set_meta_builder pairs
      pairs.each_pair do |token,klass|
        attr_meta_builder(token) unless meta_builders.has_key?(token)
        self.meta_builders[token] = klass
      end
    end

  end

  def self.included klass #:nodoc:
    klass.extend ClassMethods
  end

end
end end
