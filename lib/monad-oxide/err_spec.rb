require 'monad-oxide'

describe MonadOxide::Err do

  # The constructor tests (MonadOxide::Err.new()) are exactly the same as the
  # helper (MonadOxide.err()).
  ctor_tests = ->(ctor) {

    it 'creates an Err from the data provided' do
      expect(ctor.call('foo').unwrap_err()).to(eq('foo'))
    end

    it 'establishes a backtrace for an unraised Exception' do
      expect(
        ctor.call(StandardError.new('foo'))
          .unwrap_err()
          .backtrace()
      ).not_to(be_nil())
    end

    it 'retains backtraces for a raised Exception' do
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

    it 'establishes a backtrace for unraised Exceptions' do
      expect(
        ctor.call([StandardError.new('foo')])
          .unwrap_err()[0]
          .backtrace()
      ).not_to(be_nil())
    end

    it 'retains backtraces for raised Exceptions' do
      begin
        raise StandardError.new('foo')
      rescue => e
        expect(
          ctor.call([e])
            .unwrap_err()[0]
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

  context '#err?' do
    it 'is an Err' do
      expect(MonadOxide.err(StandardError.new('foo'))).to(be_err)
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

    end
  end

  context '#match' do

    it 'executes the Err branch passing the value' do
      exec = double('exec')
      expect(exec).to(receive(:call) {|arg| arg.kind_of?(StandardError) })
      MonadOxide.err(StandardError.new('foo'))
        .match({ MonadOxide::Err => exec })
    end

    it 'returns the result of the Err Proc' do
      expect(
        MonadOxide.err(StandardError.new('foo'))
          .match({ MonadOxide::Err => ->(x) { x.message().upcase() } })
      ).to(eq('FOO'))
    end

  end

  context '#ok?' do
    it 'is not an Ok' do
      expect(MonadOxide.err(StandardError.new('foo'))).not_to(be_ok)
    end
  end

  context '#or_else' do

    context 'with blocks' do
      it 'passes the data from the Err to the block' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|e|
              MonadOxide.err(StandardError.new(e.message() + 'bar'))
            }
            .unwrap_err()
            .message()
        ).to(eq('foobar'))
      end

      it 'returns an Err when raised, with the raised Exception' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|_| raise StandardError.new('flagrant') }
            .unwrap_err()
            .message()
        ).to(eq('flagrant'))
      end

      it 'returns an Err if the block returns a non-Result' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|_| 'bar' }
            .class()
        ).to(be(MonadOxide::Err))
      end

      it 'provides a Err<ResultReturnExpectedError> for non-Result returns' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|_| 'bar' }
            .unwrap_err()
            .class()
        ).to(be(MonadOxide::ResultReturnExpectedError))
      end

      it 'returns the same Err returned by the block' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|_| MonadOxide.err(StandardError.new('bar')) }
            .unwrap_err()
            .message()
        ).to(eq('bar'))
      end

      it 'returns the same Ok returned by the block' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else() {|_| MonadOxide.ok('bar') }
            .unwrap()
        ).to(eq('bar'))
      end
    end

    context 'with Procs' do
      it 'passes the data from the Err to the function' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(s) {
              MonadOxide.err(StandardError.new(s.message() + 'bar'))
            })
            .unwrap_err()
            .message()
        ).to(eq('foobar'))
      end

      it 'returns an Err when raised, with the raised Exception' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(_) { raise StandardError.new('flagrant') })
            .unwrap_err()
            .message()
        ).to(eq('flagrant'))
      end

      it 'returns an Err if the block returns a non-Result' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(_) { 'bar' })
            .class()
        ).to(be(MonadOxide::Err))
      end

      it 'provides a ResultReturnExpectedError in the Err for non-Result returns' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(_) { 'bar' })
            .unwrap_err()
            .class()
        ).to(be(MonadOxide::ResultReturnExpectedError))
      end

      it 'returns the same Err returned by the function' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(_) { MonadOxide.err(StandardError.new('bar')) })
            .unwrap_err()
            .message()
        ).to(eq('bar'))
      end

      it 'returns the same Ok returned by the function' do
        expect(
          MonadOxide.err(StandardError.new('foo'))
            .or_else(->(_) { MonadOxide.ok('bar') })
            .unwrap()
        ).to(eq('bar'))
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

  context '#unwrap_err_or_else' do

    context 'with Blocks' do
      it 'returns the wrapped data' do
        expect(MonadOxide.err('foo').unwrap_err_or_else {|| 'bar'}).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'returns the wrapped data' do
        expect(
          MonadOxide.err('foo').unwrap_err_or_else(->() {'bar'}),
        ).to(eq('foo'))
      end
    end

  end

  context '#unwrap_or' do

    it 'returns the passed data' do
      expect(MonadOxide.err('foo').unwrap_or('bar')).to(eq('bar'))
    end

  end

  context '#unwrap_or_else' do

    context 'with Blocks' do
      it 'returns the data from the passed block' do
        expect(MonadOxide.err('foo').unwrap_or_else() {|| 'bar'}).to(eq('bar'))
      end
    end

    context 'with Procs' do
      it 'returns the data from the passed function' do
        expect(MonadOxide.err('foo').unwrap_or_else(->() {'bar'})).to(eq('bar'))
      end
    end

  end
end
