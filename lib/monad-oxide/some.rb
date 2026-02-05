# frozen_string_literal: true

require_relative './option'
require_relative './error'

module MonadOxide

  ##
  # `Some' represents a present value in an `Option'. For most operations,
  # `Some' will perform some operation.
  class Some < Option

    ##
    # Constructs a `Some' with the data provided.
    # @param data [Object] The inner data this Option encapsulates.
    def initialize(data)
      @data = data
    end

    ##
    # Invokes `f' or the block with the data and returns the Option returned
    # from that. The return type is enforced.
    # @param f [Proc<A, Option<B>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Option<B>].
    # @yield Will yield a block that takes an A and returns a Option<B>. Same
    #        as `f' parameter.
    # @return [Some<B> | None] A new Option from `f' or the block. If `f'
    #         returns a non-Option, this will raise
    #         `OptionReturnExpectedError'.
    def and_then(f=nil, &block)
      option = (f || block).call(@data)
      if !option.kind_of?(Option)
        raise OptionReturnExpectedError.new(option)
      else
        option
      end
    end

    ##
    # Applies `f' or the block over the data and returns the same `Some'. No
    # changes are applied. This is ideal for logging.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Option<A>] returns self.
    def inspect_some(f=nil, &block)
      (f || block).call(@data)
      self
    end

    ##
    # Falls through. @see Option#inspect_none for how this is handled in
    # either Option case, and @see None#inspect_none for how this is handled
    # in the None case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Some] This Some.
    def inspect_none(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block over the data and returns a new `Some' with
    # the returned value.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A=Object] and returns a B.
    # @yield Will yield a block that takes an A and returns a B. Same as `f'
    #        parameter.
    # @return [Option<B>] A new `Some<B>' whose `B' is the return of `f' or
    #         the block.
    def map(f=nil, &block)
      self.class.new((f || block).call(@data))
    end

    ##
    # This is a no-op for Some. @see None#map_none.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Option<A>] This `Some'.
    def map_none(f=nil, &block)
      self
    end

    ##
    # Identifies that this is not a `None'.
    # For counterparts:
    # @see MonadOxide::Some#some?
    # @see MonadOxide::None#some?
    # @see MonadOxide::None#none?
    # @return [Boolean] `false` because this is not a `None'.
    def none?()
      false
    end

    ##
    # The None equivalent to Some#and_then. This is a no-op for Some. @see
    # None#or_else.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Option<A>] This `Some'.
    def or_else(f=nil, &block)
      self
    end

    ##
    # Identifies that this is a `Some'.
    # For counterparts:
    # @see MonadOxide::Some#none?
    # @see MonadOxide::None#some?
    # @see MonadOxide::None#none?
    # @return [Boolean] `true` because this is a `Some'.
    def some?()
      true
    end

    ##
    # Dangerously access the `Some' data. If this is a `None', an exception
    # will be raised. It is recommended to use this for tests only.
    # @return [A] The inner data of this `Some'.
    def unwrap()
      @data
    end

    ##
    # Dangerously access the `None' data. If this is a `Some', an exception
    # will be raised. It is recommended to use this for tests only.
    # @return [nil] Returns nil for `None'.
    def unwrap_none()
      raise UnwrapError.new(
        <<~EOE
          #{self.class} with #{@data.inspect()} could not be unwrapped as a
          None.
        EOE
      )
    end

  end

end
