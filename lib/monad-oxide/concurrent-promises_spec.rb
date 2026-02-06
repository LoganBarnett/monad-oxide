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

    it('flattens an Array of Ok Results in successful Future') {
      result = Concurrent::Promises.future() {
        [
          MonadOxide.ok(1),
          MonadOxide.ok(2),
          MonadOxide.ok(3),
        ]
      }.into_result()
      expect(result.unwrap()).to(eq([1, 2, 3]))
    }

    it('flattens an Array with mixed Results to Err in successful Future') {
      result = Concurrent::Promises.future() {
        [
          MonadOxide.ok(1),
          MonadOxide.err(StandardError.new('error1')),
          MonadOxide.ok(3),
          MonadOxide.err(StandardError.new('error2')),
        ]
      }.into_result()
      expect(result.unwrap_err().map(&:message)).to(eq(['error1', 'error2']))
    }

    it('flattens an Array of Results in the error branch using rescue') {
      result = Concurrent::Promises.future() {
        raise StandardError.new('will be rescued')
      }
        .rescue() { |e|
          [
            MonadOxide.ok(1),
            MonadOxide.err('error'),
          ]
        }
        .into_result()
      expect(result.unwrap_err().map(&:message)).to(eq(['error']))
    }

    it('preserves non-Array values in successful Future') {
      result = Concurrent::Promises.future() {
        42
      }.into_result()
      expect(result.unwrap()).to(eq(42))
    }

    it('preserves Array of non-Results in successful Future') {
      result = Concurrent::Promises.future() {
        [1, 2, 3]
      }.into_result()
      expect(result.unwrap()).to(eq([1, 2, 3]))
    }

  }

}
