module Ghaki #:nodoc:
module Meta  #:nodoc:
module Dict  #:nodoc:

class Storage

  attr_accessor :snake, :title, :camel

  def initialize
    @snake = {}
    @title = {}
    @camel = {}
  end

  %w{ snake title camel }.each do |rule|
    class_eval <<-"END"

      def put_#{rule} token, value
        @#{rule}[token] = value
      end

    END
  end

  def get_snake token
    if @snake[token].nil?
      raise ArgumentError, "Unknown Token: #{token}"
    end
    @snake[token]
  end

  def get_title token
    if @title[token].nil?
      put_title token, snake_to_title( get_snake(token) )
    end
    @title[token] 
  end

  def get_camel token
    if @camel[token].nil?
      put_camel token, title_to_camel( get_title(token) )
    end
    @camel[token]
  end

  def opt_set opts, put, value
    put_snake put, (opts[put] || value)
  end
  def opt_plural opts, put, get
    put_snake put, (opts[put] || get_snake(get) + 's')
  end
  def opt_alias opts, put, get
    put_snake put, (opts[put] || get_snake(get))
  end

  def snake_to_title text
    text.split('_').map do |x| x.capitalize end.join(' ')
  end
  def title_to_camel text
    text.gsub(' ','')
  end
  def snake_to_camel text
    title_to_camel snake_to_title(text)
  end

end
end end end
