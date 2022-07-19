
module MonadOxide
  class Err < Result
    def initialize(data)
      if !data.kind_of?(Exception)
        raise TypeError.new("#{data.inspect} is not an Exception.")
      else
        begin
          # Ruby Exceptions do not come with a backtrace. During the act of
          # raising an Exception, that Exception is granted a backtrace. So any
          # kind of `Exception.new()' invocations will have a `nil' value for
          # `backtrace()'. To get around this, we can simply raise the Exception
          # here, and then we get the backtrace we want.
          #
          # On a cursory search, this is not documented behavior.
          if data.backtrace.nil?
            raise data
          else
            @data = data
          end
        rescue => e
          @data = e
        end
      end
    end

    def and_then(f=nil, &block)
      self
    end

    def inspect_err(f=nil, &block)
      begin
        (f || block).call(@data)
        self
      rescue => e
        self.class.new(e)
      end
    end

    def inspect_ok(f=nil, &block)
      self
    end

    def map(f=nil, &block)
      self
    end

    def map_err(f=nil, &block)
      begin
        self.class.new((f || block).call(@data))
      rescue => e
        self.class.new(e)
      end
    end

    def unwrap()
      raise UnwrapError.new(
        "#{self.class} with #{@data.inspect} could not be unwrapped as an Ok.",
      )
    end

    def unwrap_err()
      @data
    end
  end
end
