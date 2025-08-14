# frozen_string_literal: true
################################################################################
# Provide an Either type (either one thing or another thing).  Either represents
# this with a Left or a Right.  The notable difference is Either doesn't assume
# one of the branches must be some kind of error - in fact no branch of Either
# has any preference to Left or Right.
#
# This is not part of Rust's standard library but it fits well with the monadic
# operations that Rust has with Result and Option.  This particular
# implementation is a port from the Either library for Rust
# (https://docs.rs/either/latest/either/enum.Either.html).
#
# Be mindful that an Either can raise exceptions if errors are present in its
# calls.  Since Either is not strictly compatible with Result, we cannot safely
# convert some operation to a Result implicitly.
################################################################################

require_relative './error'

module MonadOxide

  ##
  # Thie Exception signals an area under construction, or somehow the consumer
  # wound up with a `Result' and not one of its subclasses (@see Ok and @see
  # Err). Implementors of new methods on `Ok' and `Err' should create methods on
  # `Result' as well which immediately raise this `Exception'.
  class EitherMethodNotImplementedError < MonadOxideError; end

  ##
  # This `Exception' is produced when a method that expects the function or
  # block to provide a `Result' but was given something else. Generally this
  # Exception is not raised, but instead converts the Result into a an Err.
  # Example methods with this behavior are Result#and_then and Result#or_else.
  class EitherReturnExpectedError < MonadOxideError
    ##
    # The transformation expected a `Result' but got something else.
    # @param data [Object] Whatever we got that wasn't a `Result'.
    def initialize(data)
      super("An Either was expected but got #{data.inspect()}.")
      data = @data
    end
    attr_reader(:data)
  end

  class Either

    def initialize(_data)
      raise NoMethodError.new('Do not use Either directly. See Left and Right.')
    end

    ##
    # Use pattern matching to work with both Left and Right variants. This is
    # useful when it is desirable to have both variants handled in the same
    # location.  It can also be useful when either variant can coerced into a
    # non-Result type.
    #
    # Ruby has no built-in pattern matching, but the next best thing is a Hash
    # using the Either classes themselves as the keys.
    #
    # Tests for this are found in the tests of the Left and Right classes.
    #
    # @param matcher [Hash<Class, Proc<T | E, R>] matcher The matcher to match
    # upon.
    # @option matcher [Proc] MonadOxide::Left The branch to execute for Left.
    # @option matcher [Proc] MonadOxide::Right The branch to execute for Right.
    # @return [R] The return value of the executed Proc.
    def match(matcher)
      matcher[self.class()].call(@data)
    end

  end

end
