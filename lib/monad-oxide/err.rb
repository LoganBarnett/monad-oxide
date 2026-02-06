# frozen_string_literal: true

module MonadOxide
  ##
  # Err is the error case for Result.
  #
  # Any methods in Result that would process a successful Result (Ok) will fall
  # through with Err instances.
  class Err < Result

    ##
    # Add a backtrace to an Exception, or just pass long whatever was given.
    # The Exception is mutated in the process.
    #
    # Ruby Exceptions do not come with a backtrace. During the act of raising
    # an Exception, that Exception is granted a backtrace. So any kind of
    # `Exception.new()' invocations will have a `nil' value for `backtrace()'.
    # To get around this, we can simply raise the Exception here, and then we
    # get the backtrace we want.
    #
    # On a cursory search, this is not documented behavior.
    #
    # @param x [Exception] The potential Exception to add a backtrace to, if
    #                      it is missing a backtrace.
    # @returns [Exception] The passed value, with a backtrace added if it is
    #                      an Exception.  Non-Exceptions are wrapped in an
    #                      Exception.
    def self.backtrace_fix(x)
      if  !x.kind_of?(Exception)
        raise StandardError.new(x)
      elsif x.kind_of?(Exception) && x.backtrace.nil?()
        raise x
      else # Must be Exception with a backtrace already.
        x
      end
    rescue => e
      e
    end

    ##
    # Create an Err.
    #
    # If the Exception provided was not thrown (ie. created with Exception.new),
    # it will not have a backtrace. The Err constructor takes care of this by
    # raising the Exception and immediately capturing the Exception - this
    # causes the backtrace to be populated and will be availabl to any cosumers
    # automatically.
    #
    # @param data [T|Array<T>] The data for this Err.  If it is an Exception or
    #                          an Array of Exceptions, this will add a backtrace
    #                          if it the Exceptions do not have backtraces
    #                          already.  Exception it will result in a
    #                          TypeError.
    def initialize(data)
      if data.kind_of?(Array)
        @data = data.map(&self.class.method(:backtrace_fix))
      else
        @data = self.class.backtrace_fix(data)
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
    # Identifies that this is an `Err`.
    # For counterparts:
    # @see MonadOxide::Ok#ok?
    # @see MonadOxide::Ok#err?
    # @see MonadOxide::Err#ok?
    # @return [Boolean] `true` because this is an `Err`.
    def err?()
      true
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
    # Identifies that this is not an `Ok`.
    # For counterparts:
    # @see MonadOxide::Ok#ok?
    # @see MonadOxide::Ok#err?
    # @see MonadOxide::Err#err?
    # @return [Boolean] `false` because this is not an `Ok`.
    def ok?()
      false
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

    ##
    # Safely unwrap the `Result`.  In the case of `Err`, this returns the
    # wrapped value.
    #
    # @param _f A dummy function.  Not used.
    # @return [T] The wrapped value.
    def unwrap_err_or_else(f=nil, &_block)
      @data
    end

    ##
    # Safely unwrap the `Result`. In the case of `Err`, this returns the
    # provided default value.
    #
    # @param [T] x The value that will be returned.
    # @return [T] The `x` value.
    def unwrap_or(x)
      x
    end

    ##
    # Safely unwrap the `Result`. In the case of `Err`, this uses the provided
    # function to produce a value.
    #
    # @param f [Proc<B>] The function to call. Could be a block
    #          instead.  Takes nothing and returns a [B=Object].
    # @yield Will yield a block that takes nothing and returns a [B=Object].
    #        Same as `f' parameter.
    # @return [B] The value returned from `f`.
    def unwrap_or_else(f=nil, &block)
      (f || block).call()
    end

  end
end
