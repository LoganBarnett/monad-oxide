require 'monad-oxide'
require 'some'
require 'none'

describe MonadOxide::Some do

  context '#and_then' do

    context 'with blocks' do
      it 'passes the data from the Some to the block' do
        expect(
          MonadOxide.some('foo')
            .and_then() {|s| MonadOxide.some(s + 'bar') }
            .unwrap()
        ).to(eq('foobar'))
      end

      it 'raises OptionReturnExpectedError if block returns non-Option' do
        expect {
          MonadOxide.some('foo')
            .and_then() {|_| 'bar' }
        }.to(raise_error(MonadOxide::OptionReturnExpectedError))
      end

      it 'returns the same Some returned by the block' do
        expect(
          MonadOxide.some('foo')
            .and_then() {|_| MonadOxide.some('bar') }
            .unwrap()
        ).to(eq('bar'))
      end

      it 'returns the same None returned by the block' do
        expect(
          MonadOxide.some('foo')
            .and_then() {|_| MonadOxide.none() }
            .none?()
        ).to(be(true))
      end
    end

    context 'with Procs' do
      it 'passes the data from the Some to the function' do
        expect(
          MonadOxide.some('foo')
            .and_then(->(s) { MonadOxide.some(s + 'bar') })
            .unwrap()
        ).to(eq('foobar'))
      end

      it 'raises OptionReturnExpectedError if function returns non-Option' do
        expect {
          MonadOxide.some('foo')
            .and_then(->(_) { 'bar' })
        }.to(raise_error(MonadOxide::OptionReturnExpectedError))
      end

      it 'returns the same Some returned by the function' do
        expect(
          MonadOxide.some('foo')
            .and_then(->(_) { MonadOxide.some('bar') })
            .unwrap()
        ).to(eq('bar'))
      end

      it 'returns the same None returned by the function' do
        expect(
          MonadOxide.some('foo')
            .and_then(->(_) { MonadOxide.none() })
            .none?()
        ).to(be(true))
      end
    end

  end

  context '#inspect_some' do

    context 'with blocks' do
      it 'passes the data to the block and returns the same Some' do
        ran = false
        result = MonadOxide.some('foo')
          .inspect_some() {|s| ran = (s == 'foo') }
        expect(ran).to(be(true))
      end

      it 'returns the original Some' do
        expect(
          MonadOxide.some('foo')
            .inspect_some() {|_| 'bar' }
            .unwrap()
        ).to(eq('foo'))
      end
    end

    context 'with Procs' do
      it 'passes the data to the function and returns the same Some' do
        ran = false
        result = MonadOxide.some('foo')
          .inspect_some(->(s) { ran = (s == 'foo') })
        expect(ran).to(be(true))
      end

      it 'returns the original Some' do
        expect(
          MonadOxide.some('foo')
            .inspect_some(->(_) { 'bar' })
            .unwrap()
        ).to(eq('foo'))
      end
    end

  end

  context '#inspect_none' do

    it 'falls through and returns the Some' do
      expect(
        MonadOxide.some('foo')
          .inspect_none() { 'bar' }
          .unwrap()
      ).to(eq('foo'))
    end

  end

  context '#map' do

    context 'with blocks' do
      it 'passes the data to the block and returns a new Some' do
        expect(
          MonadOxide.some('foo')
            .map() {|s| s.upcase() }
            .unwrap()
        ).to(eq('FOO'))
      end
    end

    context 'with Procs' do
      it 'passes the data to the function and returns a new Some' do
        expect(
          MonadOxide.some('foo')
            .map(->(s) { s.upcase() })
            .unwrap()
        ).to(eq('FOO'))
      end
    end

  end

  context '#map_none' do

    it 'falls through and returns the Some' do
      expect(
        MonadOxide.some('foo')
          .map_none() { 'bar' }
          .unwrap()
      ).to(eq('foo'))
    end

  end

  context '#none?' do

    it 'returns false for Some' do
      expect(MonadOxide.some('foo').none?()).to(be(false))
    end

  end

  context '#or_else' do

    it 'falls through and returns the Some' do
      expect(
        MonadOxide.some('foo')
          .or_else() { MonadOxide.some('bar') }
          .unwrap()
      ).to(eq('foo'))
    end

  end

  context '#some?' do

    it 'returns true for Some' do
      expect(MonadOxide.some('foo').some?()).to(be(true))
    end

  end

  context '#unwrap' do

    it 'returns the data for Some' do
      expect(MonadOxide.some('foo').unwrap()).to(eq('foo'))
    end

  end

  context '#unwrap_none' do

    it 'raises UnwrapError for Some' do
      expect {
        MonadOxide.some('foo').unwrap_none()
      }.to(raise_error(MonadOxide::UnwrapError))
    end

  end

end
