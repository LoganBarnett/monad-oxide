# frozen_string_literal: true
################################################################################
# Houses generic exception types.
#
# Not to be mistaken with err.rb for MonadOxide::Err.
################################################################################
module MonadOxide

  ##
  # All errors in monad-oxide should inherit from this error. This makes it easy
  # to handle library-wide errors on the consumer side.
  class MonadOxideError < StandardError; end

  ##
  # This `Exception' is raised when the consumer makes a dangerous wager
  # about which state the `Result' is in, and lost. More specifically: An `Ok'
  # cannot unwrap an Exception, and an `Err' cannot unwrap the `Ok' data.
  class UnwrapError < MonadOxideError; end

end
