# frozen_string_literal: true
################################################################################
# Defines Left, a variant of Either.
################################################################################

require_relative './error'

module MonadOxide

  ##
  # `Left' represents an arbitrary branch of Either.  Since Either is supposed
  # to be unbiased, you can assign any bias you like to Left, though in some
  # ecosystems (such as Haskell, where this Either is ultimately inspired from),
  # the Left side is the less common/favorable one, but this is only out of
  # convention.
  class Left < Either

    ##
    # Constructs a `Left' with the data provided.
    # @param data [Object] The inner data this Either encapsulates.
    def initialize(data)
      @data = data
    end

    ##
    # Applies `f` or the block over the data and returns the same `Left`.  No
    # changes are applied.  This is ideal for logging.  @see Either#inspect_left
    # for a higher level understanding how this works with Eithers in general.
    # @param f [Proc<A, _>] The function to call. Could be a block instead.
    #          Takes an `A` the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored.  Same as
    #        `f' parameter.
    # @return [Either<A, B>] returns self.
    def inspect_left(f=nil, &block)
      (f || block).call(@data)
      self
    end

    ##
    # Falls through. @see Either#inspect_right for how this is handled in the
    # Either case, and @see Right#inspect_right for how this is handled in the
    # Right case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Either] This Either.
    def inspect_right(f=nil, &block)
      self
    end

    ##
    # Identifies that this is a `Left`.
    # For counterparts:
    # @see MonadOxide::Left#right?
    # @see MonadOxide::Right#left?
    # @see MonadOxide::Right#right?
    # @return [Boolean] `true` because this is a `Left`.
    def left?()
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
    def left_and_then(f=nil, &block)
      either = (f || block).call(@data)
      if either.is_a?(Either)
        either
      else
        raise EitherReturnExpectedError.new(either)
      end
    end


    ##
    # Applies `f' or the block over the data and returns a new `Left' with the
    # returned value.
    # @param f [Proc<A, C>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and returns a C.
    # @yield Will yield a block that takes an A and returns a C. Same as
    #        `f' parameter.
    # @return [Either<C, B>] A new `Left<C>' whose `C' is the return of `f' or
    #         the block.
    def map_left(f=nil, &block)
      Left.new((f || block).call(@data))
    end

    ##
    # This is a no-op for Left. @see Right#map_right.
    # @param f [Proc<A, C>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Either<A, B>] This `Left'.
    def map_right(f=nil, &block)
      self
    end

    ##
    # Identifies that this is not a `Right`.
    # For counterparts:
    # @see MonadOxide::Left#left?
    # @see MonadOxide::Right#left?
    # @see MonadOxide::Right#right?
    # @return [Boolean] `false` because this is not a `Right`.
    def right?()
      false
    end

    ##
    # The Left equivalent to Right#left_and_then.  This is a no-op for Left.
    # @see Right#right_and_then.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Either<A, B>] This `Either'.
    def right_and_then(f=nil, &block)
      self
    end

    ##
    # Dangerously access the `Left' data.  If this is a `Right', an
    # `UnwrapError` will be raised.  It is recommended to use this for tests
    # only.
    # @return [A] The inner data of this `Left'.
    def unwrap_left()
      @data
    end

    ##
    # Dangerously access the `Right' data.  Since this is a `Left', it will
    # always raise an error.  @see Either#unwrap_right.  It is recommended to
    # use this for tests only.
    # @return [E] The data of this `Right'.
    def unwrap_right()
      raise UnwrapError.new(
        <<~EOE
          #{self.class()} with #{@data.inspect()} could not be unwrapped as a
          Right.
        EOE
      )
    end

  end

end
