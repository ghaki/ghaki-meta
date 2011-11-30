require 'ghaki/meta/dict/storage'
require 'ghaki/meta/dict/lookup'

module Ghaki #:nodoc:
module Meta  #:nodoc:
module Dict  #:nodoc:

class Base

  def self.dict_lookup_rule *words
    list = []
    words.each do |word|
      list.push <<-"END"
        def #{word}
          @lookups[ :#{word} ] ||=
            Lookup.new( :#{word}, :dict_storage => @storage )
        end
      END
    end
    class_eval list.join("\n")
  end

  def initialize
    @storage = Storage.new
    @lookups = {}
  end

end
end end end
