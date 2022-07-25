
module MonadOxide
  ##
  # Err is the error case for Result.
  #
  # Any methods in Result that would process a successful Result (Ok) will fall
  # through with Err instances.
  class Err < Result
    ##
    # Create an Err.
    #
    # If the Exception provided was not thrown (ie. created with Exception.new),
    # it will not have a backtrace. The Err constructor takes care of this by
    # raising the Exception and immediately capturing the Exception - this
    # causes the backtrace to be populated and will be availabl to any cosumers
    # automatically.
    #
    # @param data [Exception] This must be an Exception it will result in a
    #                         TypeError.
    # @raise [TypeError] Is raised if the input is not an Exception.
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

    ##
    # Falls through. @see Result#and_then for how this is handled in either
    # Result case, and @see Ok.and_then for how this is handled in the Ok case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Err] This Err.
    def and_then(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block over the `Exception' and returns the same `Err'.
    # No changes are applied. This is ideal for logging.  Exceptions raised
    # during these transformations will return an `Err' with the Exception.
    # @param f [Proc<A=Exception>] The function to call. Could be a block
    #          instead.  Takes an [A] the return is ignored.
    # @yield Will yield a block that takes an A the return is ignored. Same as
    #        `f' parameter.
    # @return [Result<A, E>] returns self.
    def inspect_err(f=nil, &block)
      begin
        (f || block).call(@data)
        self
      rescue => e
        self.class.new(e)
      end
    end

    ##
    # Falls through. @see Result#inspect_ok for how this is handled in either
    # Result case, and @see Ok.inspect_ok for how this is handled in the Ok
    # case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Err] This Err.
    def inspect_ok(f=nil, &block)
      self
    end

    ##
    # Falls through. @see Result#map for how this is handled in either
    # Result case, and @see Ok.map for how this is handled in the Ok case.
    # @param f [Proc] Optional Proc - ignored.
    # @yield An ignored block.
    # @return [Err] This Err.
    def map(f=nil, &block)
      self
    end

    ##
    # Applies `f' or the block over the data and returns a new new `Err' with
    # the returned value.
    # @param f [Proc<A, B>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and returns a B.
    # @yield Will yield a block that takes an A and returns an Err<B>. Same as
    #        `f' parameter.
    # @return [Result<B>] A new `Err<B>' whose `B' is the return of `f' or the
    #         block. Errors raised when applying `f' or the block will result in
    #         a returned `Err<Exception>'.
    def map_err(f=nil, &block)
      begin
        self.class.new((f || block).call(@data))
      rescue => e
        self.class.new(e)
      end
    end

    ##
    # Invokes `f' or the block with the data and returns the Result returned
    # from that. Exceptions raised during `f' or the block will return an
    # `Err<Exception>'. The return type is enforced.
    # @param f [Proc<A, Result<B>>] The function to call. Could be a block
    #          instead. Takes an [A=Object] and must return a [Result<B>].
    # @yield Will yield a block that takes an A and returns a Result<B>. Same as
    #        `f' parameter.
    # @return [Err<C> | Err<Exception>] A new Result from `f' or the block.
    #         Exceptions raised will result in `Err<Exception>'. If `f' returns
    #         a non-Result, this will return `Err<ResultReturnExpectedError>'.
    def or_else(f=nil, &block)
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
    # Dangerously try to access the `Result' data. If this is an `Err', an
    # exception will be raised. It is recommended to use this for tests only.
    # @return [A] The inner data of this `Result'.
    def unwrap()
      raise UnwrapError.new(
        "#{self.class} with #{@data.inspect} could not be unwrapped as an Ok.",
      )
    end

    ##
    # Dangerously access the `Err' data. If this is an `Ok', an exception will
    # be raised. It is recommended to use this for tests only.
    # @return [E] The `Exception' of this `Err'.
    def unwrap_err()
      @data
    end
  end
end
