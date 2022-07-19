require_relative './result'

module MonadOxide
  class ResultReturnExpectedError < StandardError
    def initialize(data)
      super("A Result was expected but got #{data.inspect}.")
      data = @data
    end

    attr_reader(:data)
  end

  ##
  # `Ok' represents a success `Result'. For most operations, `Ok' will perform
  # some operation. Exceptions raised during calls to `Ok' will coerce the chain
  # into `Err', which generally causes execution to fall through the entire
  # chain.
  class Ok < Result
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
    #
    def inspect_err(f=nil, &block)
      self
    end

    ##
    #
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
    # @yield Will yield a block that takes an A and returns a Result<B>. Same as
    #        `f' parameter.
    # @return [Result<B>] A new `Ok<B>' whose `B' is the return of `f' or the
    #         block. Errors raised when applying `f' or the block will result in
    # a returned `Err<Error>'.
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
    # Dangerously try to access the `Result' data. If this is an `Err', an
    # exception will be raised. It is recommended to use this for tests only.
    # @return [A] The inner data of this `Result'.
    def unwrap()
      @data
    end

    def unwrap_err()
      raise UnwrapError.new(
        "#{self.class} with #{@data.inspect} could not be unwrapped as an Err.",
      )
    end
  end
end
