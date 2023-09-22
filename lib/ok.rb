require_relative './result'

module MonadOxide
  ##
  # `Ok' represents a success `Result'. For most operations, `Ok' will perform
  # some operation. Exceptions raised during calls to `Ok' will coerce the chain
  # into `Err', which generally causes execution to fall through the entire
  # chain.
  class Ok < Result
    ##
    # Constructs an `Ok' with the data provided.
    # @param data [Object] The inner data this Result encapsulates.
    def initialize(data)
      @data = data
    end

    ##
    # Invokes `f' or the block with the data and returns the Result returned
    # from that. Exceptions raised during `f' or the block will return an
    # `Err<Exception>'. The return type is enforced.
    # @param f [Proc<A, Result<B>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Result<B>].
    # @yield Will yield a block that takes an A and returns a Result<B>. Same as
    #        `f' parameter.
    # @return [Ok<B> | Err<C>] A new Result from `f' or the block. Exceptions
    #         raised will result in `Err<C>'. If `f' returns a non-Result, this
    #         will return `Err<ResultReturnExpectedError>'.
    def and_then(f=nil, &block)
      begin
        r = (f || block).call(@data)
        # Enforce that we always get a Result. Without a Result, coerce to an
        # Err.
        if !r.kind_of?(Result)
          raise ResultReturnExpectedError.new(r)
        else
          r
        end
      rescue => e
        Err.new(e)
      end
    end

    ##
    # Falls through. @see Result#inspect_err for how this is handled in either
    # Result case, and @see Err.inspect_err for how this is handled in the Err
    # case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Ok] This Ok.
    def inspect_err(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block over the data and returns the same `Ok'. No
    # changes are applied. This is ideal for logging.  Exceptions raised during
    # these transformations will return an `Err' with the Exception.
    # @param f [Proc<A, B>] The function to call. Could be a block instead.
    #          Takes an [A] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Result<A>] returns self.
    def inspect_ok(f=nil, &block)
      begin
        (f || block).call(@data)
        self
      rescue => e
        Err.new(e)
      end
    end

    ##
    # Applies `f' or the block over the data and returns a new new `Ok' with the
    # returned value.
    # @param f [Proc<A, B>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and returns a B.
    # @yield Will yield a block that takes an A and returns a B. Same as
    #        `f' parameter.
    # @return [Result<B>] A new `Ok<B>' whose `B' is the return of `f' or the
    #         block. Errors raised when applying `f' or the block will result in
    #         a returned `Err<Exception>'.
    def map(f=nil, &block)
      begin
        self.class.new((f || block).call(@data))
      rescue => e
        Err.new(e)
      end
    end

    ##
    # This is a no-op for Ok. @see Err#map_err.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Result<A>] This `Ok'.
    def map_err(f=nil, &block)
      self
    end

    ##
    # The Err equivalent to Ok#and_then. This is a no-op for Ok. @see
    # Err#or_else.
    # @param f [Proc<A, B>] A dummy function. Not used.
    # @yield A dummy block. Not used.
    # @return [Result<A>] This `Ok'.
    def or_else(f=nil, &block)
      self
    end

    ##
    # Dangerously access the `Ok' data. If this is an `Err', an exception will
    # be raised. It is recommended to use this for tests only.
    # @return [A] The inner data of this `Ok'.
    def unwrap()
      @data
    end

    ##
    # Dangerously access the `Err' data. If this is an `Ok', an exception will
    # be raised. It is recommended to use this for tests only.
    # @return [E] The `Exception' of this `Err'.
    def unwrap_err()
      raise UnwrapError.new(
        "#{self.class} with #{@data.inspect} could not be unwrapped as an Err.",
      )
    end

    ##
    # Safely unwrap the `Result`. In the case of `Ok`, this returns the
    # data in the Ok.
    #
    # @param [B] x The value that will be returned.
    # @return [A] The data in the Ok.
    def unwrap_or(_)
      @data
    end

  end
end
