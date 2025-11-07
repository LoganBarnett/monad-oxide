# frozen_string_literal: true
################################################################################
# An Option represents a value that may or may not be present.  Some languages
# also calls this a Maybe.  This is represented by two subclasses: Some and
# None.  Some represents a present value, and None means no value is present.
# It is advantageous to use this over `nil` because, unlike `nil`, you can
# compose over `Option`.
################################################################################

module MonadOxide

  ##
  # Thie Exception signals an area under construction, or somehow the consumer
  # wound up with a base class instance and not one of its
  # subclasses. Implementors of new methods on subclasses should
  # create methods on the base class as well which immediately raise this
  # `Exception'.
  class OptionMethodNotImplementedError < MonadOxideError; end

  ##
  # This `Exception' is produced when a method that expects the function or
  # block to provide a `Result' but was given something else. Generally this
  # Exception is not raised, but instead converts the Result into a an Err.
  # Example methods with this behavior are Result#and_then and Result#or_else.
  class OptionReturnExpectedError < MonadOxideError
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
  # An Option is a chainable series of sequential transformations. The Option
  # structure contains a `Some<A> | None`. This is the central location
  # for documentation between both `Some' and `None'. It is best to think of
  # any given `Some' or `None' as an `Option' instead. All methods on `Some'
  # are present on `None' and vice versa. This way we can interchange one for
  # the other during virtually any call.
  #
  # This is a base-class only, and you should never see instances of these in
  # the wild.
  class Option

    def initialize(data)
      raise NoMethodError.new('Do not use Option directly. See Some and None.')
    end

    ##
    # Determine if this is a MonadOxide::Some.
    # @return [Boolean] `true` if this is a MonadOxide::Some, `false`
    # otherwise.
    def some?()
      false
    end

    ##
    # Determine if this is a MonadOxide::None.
    # @return [Boolean] `true` if this is a MonadOxide::None, `false`
    # otherwise.
    def none?()
      false
    end

    ##
    # In the case of `Some', applies `f' or the block over the data and
    # returns a new `Some' with the returned value. For `None', this method
    # falls through.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A=Object] and returns a B.
    # @yield Will yield a block that takes an A and returns a B. Same as `f'
    #        parameter.
    # @return [Option<B>] A new `Option<B>' whose `B' is the return of `f' or
    #         the block for `Some'. For `None', returns self.
    def map(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # In the case of `None', applies `f' or the block and returns a new
    # `Option' with the returned value. For `Some', this method falls through.
    # @param f [Proc<B>] The function to call. Could be a block instead. Takes
    #          nothing and returns a B.
    # @yield Will yield a block that takes nothing and returns a B. Same as
    #        `f' parameter.
    # @return [Option<B>] A new `Option<B>' whose `B' is the return of `f' or
    #         the block for `None'. For `Some', returns self.
    def map_none(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # In the case of `Some', applies `f' or the block over the data and
    # returns the same `Some'. No changes are applied. This is ideal for
    # logging. For `None', this method falls through.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Option<A>] returns self.
    def inspect_some(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # In the case of `None', applies `f' or the block and returns the same
    # `None'. No changes are applied. This is ideal for logging. For `Some',
    # this method falls through.
    # @param f [Proc<B>] The function to call. Could be a block instead. Takes
    #          nothing, the return is ignored.
    # @yield Will yield a block that takes nothing, the return is ignored.
    #        Same as `f' parameter.
    # @return [Option] returns self.
    def inspect_none(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # For `Some', invokes `f' or the block with the data and returns the
    # Option returned from that.
    #
    # For `None', returns itself and the function/block are ignored.
    #
    # This method is used for control flow based on `Option' values.
    #
    # `and_then' is desirable for chaining together other Option based
    # operations, or doing transformations where flipping from a `Some' to a
    # `None' is desired. In cases where there is little/no risk of a `None'
    # state, @see Option#map.
    #
    # The `None' equivalent operation is @see Option#or_else.
    #
    # The return type is enforced.
    #
    # @param f [Proc<A, Option<B>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Option<B>].
    # @yield Will yield a block that takes an A and returns a Option<B>. Same
    #        as `f' parameter.
    # @return [Some<B> | None] A new Option from `f' or the block. If `f'
    #         returns a non-Option, this will raise
    #         `OptionReturnExpectedError'.
    def and_then(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # For `None', invokes `f' or the block and returns the Option returned
    # from that.
    #
    # For `Some', returns itself and the function/block are ignored.
    #
    # This method is used for control flow based on `Option' values.
    #
    # `or_else' is desirable for chaining together other Option based
    # operations, or doing transformations where flipping from a `None' to a
    # `Some' is desired.
    #
    # The `Some' equivalent operation is @see Option#and_then.
    #
    # The return type is enforced.
    #
    # @param f [Proc<Option<B>>] The function to call. Could be a block
    #          instead. Takes nothing and must return a [Option<B>].
    # @yield Will yield a block that takes nothing and returns a Option<B>.
    #        Same as `f' parameter.
    # @return [Some<B> | None] A new Option from `f' or the block. If `f'
    #         returns a non-Option, this will raise
    #         `OptionReturnExpectedError'.
    def or_else(f=nil, &block)
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # Dangerously access the `Option' data. If this is a `None', an exception
    # will be raised. It is recommended to use this for tests only.
    # @raise [UnwrapError] if called on a `None'.
    # @return [A] - The inner data of this `Some'.
    def unwrap()
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # Dangerously access the `Option' data. If this is a `Some', an exception
    # will be raised. It is recommended to use this for tests only.
    # @raise [UnwrapError] if called on a `Some'.
    # @return [nil] - Returns nil for `None'.
    def unwrap_none()
      raise OptionMethodNotImplementedError.new()
    end

    ##
    # Use pattern matching to work with both Some and None variants. This is
    # useful when it is desirable to have both variants handled in the same
    # location. It can also be useful when either variant can coerced into a
    # non-Option type.
    #
    # Ruby has no built-in pattern matching, but the next best thing is a
    # Hash using the Option classes themselves as the keys.
    #
    # Tests for this are found in Some and None's tests.
    #
    # @param matcher [Hash<Class, Proc<T, R>] matcher The matcher to match
    # upon.
    # @option matcher [Proc] MonadOxide::Some The branch to execute for Some.
    # @option matcher [Proc] MonadOxide::None The branch to execute for None.
    # @return [R] The return value of the executed Proc.
    def match(matcher)
      if self.kind_of?(None)
        matcher[self.class].call()
      else
        matcher[self.class].call(@data)
      end
    end

  end

end
