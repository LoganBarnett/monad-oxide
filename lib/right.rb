# frozen_string_literal: true
################################################################################
#
################################################################################

require_relative './error'

module MonadOxide

  ##
  # `Right' represents an arbitrary branch of Either.  Since Either is supposed
  # to be unbiased, you can assign any bias you like to Right, though in some
  # ecosystems (such as Haskell, where this Either is ultimately inspired from),
  # the Right side is the more common/favorable one, but this is only out of
  # convention.
  class Right < Either

    def initialize(data)
      @data = data
    end

    ##
    # Falls through. @see Either#inspect_left for how this is handled in the
    # Either case, and @see Left#inspect_left for how this is handled in the
    # Left case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Either] This Either.
    def inspect_left(f=nil, &block)
      self
    end

    ##
    # Applies `f` or the block over the data and returns the same `Right`.  No
    # changes are applied.  This is ideal for logging.  @see
    # Either#inspect_right for a higher level understanding how this works with
    # Eithers in general.
    # @param f [Proc<A, _>] The function to call. Could be a block instead.
    #          Takes an `A` the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored.  Same as
    #        `f' parameter.
    # @return [Either<A, B>] returns self.
    def inspect_right(f=nil, &block)
      (f || block).call(@data)
      self
    end

    ##
    # Identifies that this is not a `Left`.
    # For counterparts:
    # @see MonadOxide::Left#left?
    # @see MonadOxide::Left#right??
    # @see MonadOxide::Right#right?
    # @return [Boolean] `false` because this is not a `Left`.
    def left?()
      false
    end

    ##
    # The Right equivalent to Left#right_and_then.  This is a no-op for Right.
    # @see Lefft#right_and_then.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Either<A, B>] This `Either'.
    def left_and_then(f=nil, &block)
      self
    end

    ##
    # This is a no-op for Right. @see Left#map_left.
    # @param f [Proc<A, C>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Either<A, B>] This `Left'.
    def map_left(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block over the data and returns a new `Right' with the
    # returned value.
    # @param f [Proc<A, C>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and returns a C.
    # @yield Will yield a block that takes an A and returns a C. Same as
    #        `f' parameter.
    # @return [Either<A, C>] A new `Right<C>' whose `C' is the return of `f' or
    #         the block.
    def map_right(f=nil, &block)
      Right.new((f || block).call(@data))
    end

    ##
    # Identifies that this is a `Right`.
    # For counterparts:
    # @see MonadOxide::Left#left?
    # @see MonadOxide::Left#right?
    # @see MonadOxide::Right#left?
    # @return [Boolean] `true` because this is a `Right`.
    def right?()
      true
    end

    ##
    # Invokes `f' or the block with the data and returns the Either returned
    # from that.  The return type is enforced.
    # @param f [Proc<A, Result<C>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Either<C, B>].
    # @yield Will yield a block that takes an A and returns a Either<C>. Same as
    #        `f' parameter.
    # @return [Left<C> | Right<C>] A new Result from `f' or the
    #         block.  If the return value is a non-Either, this this will raise
    #         `EitherReturnExpectedError'.
    def right_and_then(f=nil, &block)
      either = (f || block).call(@data)
      if either.is_a?(Either)
        either
      else
        raise EitherReturnExpectedError.new(either)
      end
    end

    ##
    # Dangerously access the `Left' data.  Since this is a `Right', it will
    # always raise an error.  @see Either#unwrap_left.  It is recommended to use
    # this for tests only.
    # @return [A] The inner data of this `Right'.
    def unwrap_left()
      raise UnwrapError.new(
        <<~EOE
        #{self.class()} with #{@data.inspect()} could not be unwrapped as a
        Left.
        EOE
      )
    end

    ##
    # Dangerously access the `Right' data.  If this is a `Left', an
    # `UnwrapError` will be raised.  It is recommended to use this for tests
    # only.
    # @return [A] The inner data of this `Right'.
    def unwrap_right()
      @data
    end

  end

end
