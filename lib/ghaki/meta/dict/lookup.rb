require 'ghaki/meta/dict/storage'

module Ghaki #:nodoc:
module Meta  #:nodoc:
module Dict  #:nodoc:

class Lookup

  attr_accessor :token, :storage

  def initialize name, opts={}
    @token   = name
    @storage = opts[:dict_storage] || Storage.new
  end

  %w{ snake camel title }.each do |rule|
    list = []
    list.push <<-"END"

      def #{rule}
        @storage.get_#{rule}( @token )
      end

      def #{rule}= val
        @storage.put_#{rule}( @token, val )
      end

    END
    class_eval list.join("\n")
  end

  def to_s
    @storage.get_snake(@token)
  end

  def opt_plural opts, get
    @storage.opt_plural opts, @token, get
  end

  def opt_alias opts, get
    @storage.opt_alias opts, @token, get
  end

  def opt_set opts, value
    @storage.opt_set opts, @token, value
  end

end
end end end
