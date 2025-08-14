# frozen_string_literal: true

require 'monad-oxide/concurrent-promises'

describe(Concurrent::Promises::Future) {

  context('#into_result') {

    it('coerces a successful Future into a MonadOxide::Ok') {
      result = Concurrent::Promises.future() {
        'foo'
      }.into_result()
      expect(result.unwrap()).to(eq('foo'))
    }

    it('coerces a failed Future into a MonadOxide::Err') {
      result = Concurrent::Promises.future() {
        raise StandardError.new('error')
      }.into_result()
      expect(result.unwrap_err().message()).to(eq('error'))
    }

    # For some reason this is treated differently in the #result return value.
    it('coerces a failed Future into a MonadOxide::Err (rescue edition)') {
      result = Concurrent::Promises.future() {
        raise StandardError.new('error')
      }
        .rescue() { |e| raise e }
        .into_result()
      expect(result.unwrap_err().message()).to(eq('error'))
    }

  }

}
