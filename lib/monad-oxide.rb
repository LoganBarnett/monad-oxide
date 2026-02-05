# frozen_string_literal: true
require_relative './monad-oxide/result'
require_relative './monad-oxide/err'
require_relative './monad-oxide/ok'
require_relative './monad-oxide/either'
require_relative './monad-oxide/left'
require_relative './monad-oxide/right'
require_relative './monad-oxide/array'
require_relative './monad-oxide/version'
# Intentionally do not require helpers which inflict external dependencies, such
# as ./concurrent-promises.rb which requires the 'concurrent' gem.

##
# The top level module for the monad-oxide library. Of interest, @see `Result',
# @see `Err', and @see `Ok'.
module MonadOxide

  module_function

  ##
  # Create an `Err' as a conveniece method.
  # @param data [Exception] The `Exception' for this `Err'.
  # @return [Result<A, E=Exception>] the `Err' from the provided `Exception'.
  def err(data)
    MonadOxide::Err.new(data)
  end

  def left(data)
    MonadOxide::Left.new(data)
  end

  def none()
    MonadOxide::None.new()
  end

  ##
  # Create an `Ok' as a conveniece method.
  # @param data [Object] The inner data for this `Ok'.
  # @return [Result<A, E=Exception>] the `Ok' from the provided inner data.
  def ok(data)
    MonadOxide::Ok.new(data)
  end

  def option(data)
    data.nil?() ? none() : some(data)
  end

  def right(data)
    MonadOxide::Right.new(data)
  end

  def some(data)
    MonadOxide::Some.new(data)
  end

end
