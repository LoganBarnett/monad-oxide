require 'monad-oxide'
require 'ok'
require 'err'

describe MonadOxide::Err do

  # The constructor tests (MonadOxide::Err.new()) are exactly the same as the
  # helper (MonadOxide.err()).
  ctor_tests = ->(ctor) {
    it 'raises a TypeError if not provided an Exception' do
      expect { ctor.call('foo') }.to raise_error(TypeError)
    end

    it 'establishes a backtrace for unraised Exceptions' do
      expect(
        ctor.call(StandardError.new('foo'))
          .unwrap_err()
          .backtrace()
      ).not_to(be_nil())
    end

    it 'retains backtraces for raised Exceptions' do
      begin
        raise StandardError.new('foo')
      rescue => e
        expect(
          ctor.call(e)
            .unwrap_err()
            .backtrace()
        ).to(be(e.backtrace()))
      end
    end
  }

  context '#initialize' do
    ctor_tests.call(MonadOxide::Err.method(:new))
  end

  context 'MonadOxide.err' do
    ctor_tests.call(MonadOxide.method(:err))
  end

  context '#and_then' do

    context 'with blocks' do
      it 'does nothing with the block' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .and_then() {|s| effected = "effect: #{s}"}
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .and_then() { 'bar' }
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'does nothing with the function' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .and_then(->(s) { effected = "effect: #{s}"})
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .and_then(->(_) { 'bar' })
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end

  end


  context '#inspect_err' do
    context 'with blocks' do
      it 'applies the data to the block provided' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .inspect_err(->(s) { effected = "effect: #{s}"})
        expect(effected).to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_err() {|_| 'bar' }
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end

      it 'returns an Err with the error from the block' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_err() {|_| raise StandardError.new('flagrant') }
            .unwrap_err()
            .message()
          ).to(eq('flagrant'))
      end
    end

    context 'with Procs' do
      it 'applies the data to the function provided' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .inspect_err(->(s) { effected = "effect: #{s}"})
        expect(effected).to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_err(->(_) { 'bar' })
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end

      it 'returns an Err with the error from the function' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_err(->(_) { raise StandardError.new('flagrant') })
            .unwrap_err()
            .message()
          ).to(eq('flagrant'))
      end
    end
  end

  context '#inspect_ok' do
    context 'with blocks' do
      it 'does nothing with the block' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .inspect_ok() {|s| effected = "effect: #{s}"}
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_ok() { 'bar' }
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'does nothing with the function' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .inspect_ok(->(s) { effected = "effect: #{s}"})
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .inspect_ok(->(_) { 'bar' })
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end
  end


  context '#map' do
    context 'with blocks' do
      it 'does nothing with the block' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .map() {|s| effected = "effect: #{s}"}
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map() { 'bar' }
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'does nothing with the function' do
        effected = 'unset'
        MonadOxide.err(StandardError.new('foo'))
          .map(->(s) { effected = "effect: #{s}"})
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map(->(_) { 'bar' })
            .unwrap_err()
            .message()
          ).to(eq('foo'))
      end
    end
  end

  context '#map_err' do
    context 'with blocks' do
      it 'returns an Err if an error is raised in the block' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err() {|_| raise StandardError.new('bar') }
            .unwrap_err()
            .message()
          ).to(eq('bar'))
      end

      it 'returns a new Err' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err() {|_| StandardErr.new('bar') }
            .class()
          ).to(be(MonadOxide::Err))
      end

      it 'applies the block to the data for the new Ok' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err() {|e| StandardError.new(e.message() + 'bar') }
            .unwrap_err()
            .message()
          ).to(eq('foobar'))
      end

      it 'requires the mapped value is an Exception still' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err() {|_| 'bar'}
            .unwrap_err()
            .class()
          ).to(be(TypeError))
      end
    end

    context 'with Procs' do
      it 'returns an Err if an error is raised in the function' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err(->(_) { raise StandardError.new })
            .unwrap_err()
            .class()
          ).to(be(StandardError))
      end

      it 'applies the function to the data for the new Ok' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err(->(e) { StandardError.new(e.message() + 'bar') })
            .unwrap_err()
            .message()
          ).to(eq('foobar'))
      end

      it 'requires the mapped value is an Exception still' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .map_err(->(_) { 'bar' })
            .unwrap_err()
            .class()
          ).to(be(TypeError))
      end
    end
  end

  context '#unwrap' do
    it 'raises an UnwrapError' do
      expect {
        MonadOxide.err(StandardError.new('foo')).unwrap()
      }.to(raise_error(MonadOxide::UnwrapError))
    end
  end

  context '#unwrap_err' do
    it 'provides the underlying value' do
      expect(
        MonadOxide.err(StandardError.new('foo')).unwrap_err().message(),
      ).to(eq('foo'))
    end
  end
end
