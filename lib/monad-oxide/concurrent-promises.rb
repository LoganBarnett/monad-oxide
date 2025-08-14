# frozen_string_literal: true
################################################################################
# Defines a helper for concurrent/promises.
################################################################################

require 'concurrent/promises'
require_relative '../monad-oxide'

class Concurrent::Promises::Future

  ##
  # Coerces a Current::Promises::Future into a MonadOxide::Result.  This
  # behavior forces the Future to finalize, and thus is blocking behavior.
  # A successful Future becomes a MonadOxide::Ok, and a failed Future becomes a
  # MonadOxide::Err.
  # @return [MonadOxide::Result<A, E>] A coerced Result from the Future,
  # containing whatever value the Future was holding.
  def into_result()
    success, value, err = self.result()
    success ? MonadOxide.ok(value) : MonadOxide.err(
      # err isn't actually the error unless someone called rescue on the promise
      # chain.  It's pretty weird.  So we have to check for both.
      err.nil?() ? value : err,
    )
  end

end
