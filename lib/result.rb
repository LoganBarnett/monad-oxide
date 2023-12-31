module MonadOxide
  ##
  # All errors in monad-oxide should inherit from this error. This makes it easy
  # to handle library-wide errors on the consumer side.
  class MonadOxideError < StandardError; end

  ##
  # Thie Exception signals an area under construction, or somehow the consumer
  # wound up with a `Result' and not one of its subclasses (@see Ok and @see
  # Err). Implementors of new methods on `Ok' and `Err' should create methods on
  # `Result' as well which immediately raise this `Exception'.
  class ResultMethodNotImplementedError < MonadOxideError; end

  ##
  # This `Exception' is produced when a method that expects the function or
  # block to provide a `Result' but was given something else. Generally this
  # Exception is not raised, but instead converts the Result into a an Err.
  # Example methods with this behavior are Result#and_then and Result#or_else.
  class ResultReturnExpectedError < MonadOxideError
    ##
    # The transformation expected a `Result' but got something else.
    # @param data [Object] Whatever we got that wasn't a `Result'.
    def initialize(data)
      super("A Result was expected but got #{data.inspect}.")
      data = @data
    end
    attr_reader(:data)
  end

  ##
  # This `Exception' is raised when the consumer makes a dangerous wager
  # about which state the `Result' is in, and lost. More specifically: An `Ok'
  # cannot unwrap an Exception, and an `Err' cannot unwrap the `Ok' data.
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
    # Determine if this is a MonadOxide::Err.
    # @return [Boolean] `true` if this is a MonadOxide::Err, `false` otherwise.
    def err?()
      false
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

    ##
    # In the case of `Err', applies `f' or the block over the `Exception' and
    # returns the same `Err'. No changes are applied. This is ideal for logging.
    # For `Ok', this method falls through. Exceptions raised during these
    # transformations will return an `Err' with the Exception.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A=Exception] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Result<A>] returns self.
    def inspect_err(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
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
    # In the case of `Ok', applies `f' or the block over the data and returns
    # the same `Ok'. No changes are applied. This is ideal for logging.  For
    # `Err', this method falls through. Exceptions raised during these
    # transformations will return an `Err' with the Exception.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Result<A>] returns self.
    def inspect_ok(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # In the case of `Ok', applies `f' or the block over the data and returns a
    # new new `Ok' with the returned value. For `Err', this method falls
    # through. Exceptions raised during these transformations will return an
    # `Err' with the Exception.
    # @param f [Proc<A, B>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and returns a B.
    # @yield Will yield a block that takes an A and returns a B. Same as
    #        `f' parameter.
    # @return [Result<B>] A new `Result<B>' whose `B' is the return of `f' or
    #         the block. Errors raised when applying `f' or the block will
    #         result in a returned `Err<Exception>'.
    def map(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # In the case of `Err', applies `f' or the block over the `Exception' and
    # returns a new new `Err' with the returned value. For `Ok', this method
    # falls through. Exceptions raised during these transformations will return
    # an `Err' with the Exception.
    # @param f [Proc<A, B>] The function to call. Could be a block
    #          instead. Takes an [A=Exception] and returns a [B=Exception].
    # @yield Will yield a block that takes an A and returns a B. Same as
    #        `f' parameter.
    # @return [Result<B>] A new `Result<A, ErrorB>' whose `ErrorB' is the return
    #         of `f' or the block. Errors raised when applying `f' or the block
    #         will result in a returned `Err<Exception>'.
    def map_err(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # Use pattern matching to work with both Ok and Err variants. This is useful
    # when it is desirable to have both variants handled in the same location.
    # It can also be useful when either variant can coerced into a non-Result
    # type.
    #
    # Ruby has no built-in pattern matching, but the next best thing is a Hash
    # using the Result classes themselves as the keys.
    #
    # Tests for this are found in Ok and Err's tests.
    #
    # @param matcher [Hash<Class, Proc<T | E, R>] matcher The matcher to match
    # upon.
    # @option matcher [Proc] MonadOxide::Ok The branch to execute for Ok.
    # @option matcher [Proc] MonadOxide::Err The branch to execute for Err.
    # @return [R] The return value of the executed Proc.
    def match(matcher)
      matcher[self.class].call(@data)
    end

    ##
    # Determine if this is a MonadOxide::Ok.
    # @return [Boolean] `true` if this is a MonadOxide::Ok, `false` otherwise.
    def ok?()
      false
    end

    ##
    # For `Err', invokes `f' or the block with the data and returns the Result
    # returned from that. Exceptions raised during `f' or the block will return
    # an `Err<Exception>'.
    #
    # For `Ok', returns itself and the function/block are ignored.
    #
    # This method is used for control flow based on `Result' values.
    #
    # `or_else' is desirable for chaining together other Result based
    # operations, or doing transformations where flipping from an `Ok' to an
    # `Err' is desired. In cases where there is little/no risk of an `Err'
    # state, @see Result#map.
    #
    # The `Ok' equivalent operation is @see Result#and_then.
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
    def or_else(f=nil, &block)
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # Dangerously access the `Result' data. If this is an `Err', an exception
    # will be raised. It is recommended to use this for tests only.
    # @raise [UnwrapError] if called on an `Err'.
    # @return [A] - The inner data of this `Ok'.
    def unwrap()
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # Dangerously access the `Result' data. If this is an `Ok', an exception
    # will be raised. It is recommended to use this for tests only.
    # @raise [UnwrapError] if called on an `Ok'.
    # @return [E] - The inner data of this `Err'.
    def unwrap_err()
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # Safely unwrap the `Result` but with lazy evaluation.  In the case of
    # `Err`, this returns the wrapped value.  For `Ok` the function provided is
    # evaluated and its returned value is what is returned.
    #
    # @param f [Proc<B>] The function to call for `Ok`. Could be a block
    #          instead.  Takes nothing and returns a [B=Object].
    # @yield Will yield a block for `Ok` that takes nothing and returns a
    #        [B=Object].  Same as `f' parameter.
    # @return [T|B] The wrapped value for `Err` and the returned from `f` for
    #               `Ok`.
    def unwrap_err_or_else(_f)
      raise ResultMethodNotImplementedError.new()
    end

    ##
    # Attempt to safely access the `Result` data. This always returns a value
    # instead of raising an Exception. In the case of `Ok`, the data is
    # returned. In the case of `Err`, the value provided is returned.
    # @param _ [B] The value to use for `Err`.
    # @return [T|B] The inner data of this `Ok` or the passee value.
    def unwrap_or(_)
      Err.new(ResultMethodNotImplementedError.new())
    end

    ##
    # Safely unwrap the `Result` but with lazy evaluation.  In the case of
    # `Ok`, this returns the wrapped value.  For `Err` the function provided is
    # evaluated and its returned value is what is returned.
    #
    # @param f [Proc<B>] The function to call for `Err`. Could be a block
    #          instead.  Takes nothing and returns a [B=Object].
    # @yield Will yield a block for `Err` that takes nothing and returns a
    #        [B=Object].  Same as `f' parameter.
    # @return [T|B] The wrapped value for `Ok` and the returned from `f` for
    #               `Err`.
    def unwrap_or_else(_f)
      raise ResultMethodNotImplementedError.new()
    end

    ##
    # Safely unwrap the `Result` but with lazy evaluation.  In the case of `Ok`,
    # this returns the wrapped value.  For `Err` the function provided is
    # evaluated and its returned value is what is returned.
    #
    # @param f [Proc<B>] The function to call for `Err`. Could be a block
    #          instead.  Takes nothing and returns a [B=Object].
    # @yield Will yield a block for `Err` that takes nothing and returns a
    #        [B=Object].  Same as `f' parameter.
    # @return [T|B] The wrapped value for `Ok` and the returned from `f` for
    #               `Err`.
    def unwrap_or_else(_f)
      raise ResultMethodNotImplementedError.new()
    end

  end
end
