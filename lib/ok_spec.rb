require 'monad-oxide'
require 'ok'
require 'err'

describe MonadOxide::Ok do

  context '#and_then' do

    context 'with blocks' do
      it 'passes the data from the Ok to the block' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|s| MonadOxide.ok(s + 'bar') }
            .unwrap()
        ).to(eq('foobar'))
      end

      it 'converts to an Err if the block raises an error' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|_| raise StandardError.new('flagrant') }
            .class
        ).to(be(MonadOxide::Err))
      end

      it 'converts to an Err if the block returns a non-Result' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|_| 'bar' }
            .class()
        ).to(be(MonadOxide::Err))
      end

      it 'provides a ResultReturnExpectedError in the Err for non-Result returns' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|_| 'bar' }
            .unwrap_err()
            .class()
        ).to(be(MonadOxide::ResultReturnExpectedError))
      end

      it 'returns the same Ok returned by the block' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|_| MonadOxide.ok('bar') }
            .unwrap()
        ).to(eq('bar'))
      end

      it 'returns the same Err returned by the block' do
        expect(
          MonadOxide.ok('foo')
            .and_then() {|_| MonadOxide.err(StandardError.new()) }
            .unwrap_err()
            .class()
        ).to(be(StandardError))
      end
    end

    context 'with Procs' do
      it 'passes the data from the Ok to the function' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(s) { MonadOxide.ok(s + 'bar') })
            .unwrap()
        ).to(eq('foobar'))
      end

      it 'converts to an Err if the function raises an error' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(_) { raise StandardError.new('flagrant') })
            .class
        ).to(be(MonadOxide::Err))
      end

      it 'converts to an Err if the function returns a non-Result' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(_) { 'bar' })
            .class()
        ).to(be(MonadOxide::Err))
      end

      it 'provides a ResultReturnExpectedError in the Err for non-Result returns' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(_) { 'bar' })
            .unwrap_err()
            .class()
        ).to(be(MonadOxide::ResultReturnExpectedError))
      end

      it 'returns the same Ok returned by the function' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(_) { MonadOxide.ok('bar') })
            .unwrap()
        ).to(eq('bar'))
      end

      it 'returns the same Err returned by the function' do
        expect(
          MonadOxide.ok('foo')
            .and_then(->(_) { MonadOxide.err(StandardError.new()) })
            .unwrap_err()
            .class()
        ).to(be(StandardError))
      end

    end

  end

  context '#map' do
    context 'with blocks' do
      it 'returns an Err if an error is raised in the block' do
        expect(
          MonadOxide.ok('foo')
            .map() {|_| raise StandardError.new }
            .unwrap_err()
            .class()
          ).to(be(StandardError))
      end

      it 'returns a new Ok' do
        expect(
          MonadOxide.ok('foo')
            .map() {|_| 'bar' }
            .class()
          ).to(be(MonadOxide::Ok))
      end

      it 'applies the block to the data for the new Ok' do
        expect(
          MonadOxide.ok('foo')
            .map() {|s| s + 'bar' }
            .unwrap()
          ).to(eq('foobar'))
      end

      it 'allows nesting of Ok' do
        expect(
          MonadOxide.ok('foo')
            .map() {|s| MonadOxide.ok(s) }
            .unwrap()
            .class()
          ).to(be(MonadOxide::Ok))
      end

      it 'allows nesting of Err' do
        expect(
          MonadOxide.ok('foo')
            .map() {|_| MonadOxide.err(StandardError.new()) }
            .unwrap()
            .class()
          ).to(be(MonadOxide::Err))
      end
    end

    context 'with Procs' do
      it 'returns an Err if an error is raised in the function' do
        expect(
          MonadOxide.ok('foo')
            .map(->(_) { raise StandardError.new })
            .unwrap_err()
            .class()
          ).to(be(StandardError))
      end

      it 'returns a new Ok' do
        expect(
          MonadOxide.ok('foo')
            .map(->(_) { 'bar' })
            .class()
          ).to(be(MonadOxide::Ok))
      end

      it 'applies the function to the data for the new Ok' do
        expect(
          MonadOxide.ok('foo')
            .map(->(s) { s + 'bar' })
            .unwrap()
          ).to(eq('foobar'))
      end

      it 'allows nesting of Ok' do
        expect(
          MonadOxide.ok('foo')
            .map(->(s) { MonadOxide.ok(s) })
            .unwrap()
            .class()
          ).to(be(MonadOxide::Ok))
      end

      it 'allows nesting of Err' do
        expect(
          MonadOxide.ok('foo')
            .map(->(_) { MonadOxide.err(StandardError.new()) })
            .unwrap()
            .class()
          ).to(be(MonadOxide::Err))
      end
    end
  end

  context '#map_err' do
    context 'with blocks' do
      it 'does nothing with the block' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .map_err() {|s| effected = "effect: #{s}"}
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .map_err() { 'bar' }
            .unwrap()
          ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'does nothing with the function' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .map_err(->(s) { effected = "effect: #{s}"})
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .map_err(->(_) { 'bar' })
            .unwrap()
          ).to(eq('foo'))
      end
    end
  end

  context '#inspect_err' do
    context 'with blocks' do
      it 'does nothing with the block' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .inspect_err() {|s| effected = "effect: #{s}"}
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .inspect_err() { 'bar' }
            .unwrap()
          ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'does nothing with the function' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .inspect_err(->(s) { effected = "effect: #{s}"})
        expect(effected).not_to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .inspect_err(->(_) { 'bar' })
            .unwrap()
          ).to(eq('foo'))
      end
    end
  end

  context '#inspect_ok' do
    context 'with blocks' do
      it 'applies the data to the block provided' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .inspect_ok(->(s) { effected = "effect: #{s}"})
        expect(effected).to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .inspect_ok() {|_| 'bar' }
            .unwrap()
          ).to(eq('foo'))
      end

      it 'returns an Err with the error from the block' do
        expect(
          MonadOxide.ok('foo')
            .inspect_ok() {|_| raise StandardError.new('flagrant') }
            .unwrap_err()
            .class()
          ).to(be(StandardError))
      end
    end

    context 'with Procs' do
      it 'applies the data to the function provided' do
        effected = 'unset'
        MonadOxide.ok('foo')
          .inspect_ok(->(s) { effected = "effect: #{s}"})
        expect(effected).to(eq('effect: foo'))
      end

      it 'does not change the underlying data' do
        expect(
          MonadOxide.ok('foo')
            .inspect_ok(->(_) { 'bar' })
            .unwrap()
          ).to(eq('foo'))
      end

      it 'returns an Err with the error from the function' do
        expect(
          MonadOxide.ok('foo')
            .inspect_ok(->(_) { raise StandardError.new('flagrant') })
            .unwrap_err()
            .class()
          ).to(be(StandardError))
      end
    end
  end

  context '#unwrap' do
    it 'provides the underlying value' do
      expect(MonadOxide.ok('foo').unwrap()).to(eq('foo'))
    end
  end

  context '#unwrap_err' do
    it 'raises an UnwrapError' do
      expect {
        MonadOxide.ok('foo').unwrap_err()
      }.to(raise_error(MonadOxide::UnwrapError))
    end
  end
end
