# frozen_string_literal: true

require_relative './option'

module MonadOxide

  ##
  # `None' represents the absence of a value in an `Option'.
  #
  # Any methods in Option that would process a present value (Some) will fall
  # through with None instances.
  class None < Option

    ##
    # Create a None.
    def initialize()
    end

    ##
    # Falls through. @see Option#and_then for how this is handled in either
    # Option case, and @see Some#and_then for how this is handled in the Some
    # case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [None] This None.
    def and_then(f=nil, &block)
      self
    end

    ##
    # Falls through. @see Option#inspect_some for how this is handled in
    # either Option case, and @see Some#inspect_some for how this is handled
    # in the Some case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [None] This None.
    def inspect_some(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block and returns the same `None'. No changes are
    # applied. This is ideal for logging.
    # @param f [Proc<B>] The function to call. Could be a block instead. Takes
    #          nothing, the return is ignored.
    # @yield Will yield a block that takes nothing, the return is ignored.
    #        Same as `f' parameter.
    # @return [Option] returns self.
    def inspect_none(f=nil, &block)
      (f || block).call()
      self
    end

    ##
    # Falls through. @see Option#map for how this is handled in either
    # Option case, and @see Some#map for how this is handled in the Some
    # case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [None] This None.
    def map(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block and returns a new `Option' with the returned
    # value.
    # @param f [Proc<B>] The function to call. Could be a block instead. Takes
    #          nothing and returns a B.
    # @yield Will yield a block that takes nothing and returns a B. Same as
    #        `f' parameter.
    # @return [Option<B>] A new `Option<B>' whose `B' is the return of `f' or
    #         the block.
    def map_none(f=nil, &block)
      Some.new((f || block).call())
    end

    ##
    # Identifies that this is a `None'.
    # For counterparts:
    # @see MonadOxide::Some#some?
    # @see MonadOxide::Some#none?
    # @see MonadOxide::None#some?
    # @return [Boolean] `true` because this is a `None'.
    def none?()
      true
    end

    ##
    # Invokes `f' or the block and returns the Option returned from that. The
    # return type is enforced.
    # @param f [Proc<Option<B>>] The function to call. Could be a block
    #          instead. Takes nothing and must return a [Option<B>].
    # @yield Will yield a block that takes nothing and returns a Option<B>.
    #        Same as `f' parameter.
    # @return [Some<B> | None] A new Option from `f' or the block. If `f'
    #         returns a non-Option, this will raise
    #         `OptionReturnExpectedError'.
    def or_else(f=nil, &block)
      option = (f || block).call()
      if !option.kind_of?(Option)
        raise OptionReturnExpectedError.new(option)
      else
        option
      end
    end

    ##
    # Identifies that this is not a `Some'.
    # For counterparts:
    # @see MonadOxide::Some#some?
    # @see MonadOxide::Some#none?
    # @see MonadOxide::None#none?
    # @return [Boolean] `false` because this is not a `Some'.
    def some?()
      false
    end

    ##
    # Dangerously try to access the `Option' data. If this is a `None', an
    # exception will be raised. It is recommended to use this for tests only.
    # @return [A] The inner data of this `Option'.
    def unwrap()
      raise UnwrapError.new(
        "#{self.class} could not be unwrapped as a Some.",
      )
    end

    ##
    # Dangerously access the `None' data. If this is a `Some', an exception
    # will be raised. It is recommended to use this for tests only.
    # @return [nil] Returns nil for `None'.
    def unwrap_none()
      nil
    end

  end

end
