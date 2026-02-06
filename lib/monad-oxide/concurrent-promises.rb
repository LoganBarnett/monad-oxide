# frozen_string_literal: true
################################################################################
# Defines a helper for concurrent/promises.
################################################################################

require 'concurrent/promises'
require_relative '../monad-oxide'
require_relative './array'

class Concurrent::Promises::Future

  ##
  # Coerces a Current::Promises::Future into a MonadOxide::Result.  This
  # behavior forces the Future to finalize, and thus is blocking behavior.
  # A successful Future becomes a MonadOxide::Ok, and a failed Future becomes a
  # MonadOxide::Err.  If the Promise returns an Array of Results (either on the
  # Err branch or the Ok branch), flatten them.
  # @return [MonadOxide::Result<A, E>] A coerced Result from the Future,
  # containing whatever value the Future was holding.
  def into_result()
    success, value, err = self.result()
    (
      success ? MonadOxide.ok(value) : MonadOxide.err(
        err.nil?() ? value: err,
      )
    )
      .and_then(->(x) {
        x.respond_to?(:into_result) ?
          x.into_result() :
          MonadOxide.ok(x)
      })
      .or_else(->(x) {
        x.respond_to?(:into_result) ?
          x.into_result() :
          MonadOxide.err(x)
      })
  end

end
