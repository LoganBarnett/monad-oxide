require_relative './result'
require_relative './err'
require_relative './ok'
require_relative './either'
require_relative './left'
require_relative './right'
require_relative './array'
require_relative './version'

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

  ##
  # Create an `Ok' as a conveniece method.
  # @param data [Object] The inner data for this `Ok'.
  # @return [Result<A, E=Exception>] the `Ok' from the provided inner data.
  def ok(data)
    MonadOxide::Ok.new(data)
  end

  def right(data)
    MonadOxide::Right.new(data)
  end

end
