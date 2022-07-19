module MonadOxide
  ##
  # All errors in monad-oxide should inherit from this error. This makes it easy
  # to handle library-wide errors on the consumer side.
  class MonadOxideError < StandardError; end
  class ResultMethodNotImplementedError < MonadOxideError; end
  class UnwrapError < MonadOxideError; end

  ##
  # A Result is a chainable series of sequential transformations. The Result
  # structure contains an `Ok<A> | Err<Exception>`. This is the central location
  # for documentation between both `Ok` and `Err`. It is best to think of any
  # given `Ok` or `Err` as a `Result` instead. All methods on `Ok` are present
  # on `Err` and vice versa. This way we can interchange one for the other
  # during virtually any call.
  #
  # This is a base-class only, and you should never see instances of these in
  # the wild.
  class Result
    # None of these work.
    # Option 1:
    # private_class_method :new
    # Option 2:
    # class << self
    #   protected :new
    # end

    def initialize(data)
      raise NoMethodError.new('Do not use Result directly. See Ok and Err.')
    end

    ##
    # Un-nest this `Result'. This implementation is shared between `Ok' and
    # `Err'. In both cases, the structure's data is operated upon.
    # @return [Result] If `A' is a `Result' (meaning this `Result` is nested),
    # return the inner-most `Result', regardless of the depth of nesting.
    # Otherwise return `self'.
    def flatten()
      if @data.kind_of?(Result)
        return @data.flatten()
      else
        self
      end
    end

    ##
    # For `Ok', invokes `f' or the block with the data and returns the Result
    # returned from that. Exceptions raised during `f' or the block will return
    # an `Err<Exception>'.
    #
    # For `Err', returns itself and the function/block are ignored.
    #
    # This method is used for control flow based on `Result' values.
    #
    # `and_then' is desirable for chaining together other Result based
    # operations, or doing transformations where flipping from an `Ok' to an
    # `Err' is desired. In cases where there is little/no risk of an `Err'
    # state, @see Result#map.
    #
    # The `Err' equivalent operation is @see Result#or_else.
    #
    # The return type is enforced.
    #
    # @param f [Proc<A, Result<B>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Result<B>].
    # @yield Will yield a block that takes an A and returns a Result<B>. Same as
    #        `f' parameter.
    # @return [Ok<B> | Err<C>] A new Result from `f' or the block. Exceptions
    #         raised will result in `Err<C>'. If `f' returns a non-Result, this
    #         will return `Err<ResultReturnExpectedError>'.
    def and_then(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    def map(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    def map_err(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    def inspect_err(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    def inspect_ok(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    def unwrap()
      Err.new(ResultMethodNotImplementedError.new())
    end

    def unwrap_err()
      Err.new(ResultMethodNotImplementedError.new())
    end
  end
end
