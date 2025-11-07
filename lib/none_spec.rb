require 'monad-oxide'
require 'some'
require 'none'

describe MonadOxide::None do

  context '#and_then' do

    it 'falls through and returns the None' do
      expect(
        MonadOxide.none()
          .and_then() { MonadOxide.some('bar') }
          .none?()
      ).to(be(true))
    end

  end

  context '#inspect_some' do

    it 'falls through and returns the None' do
      expect(
        MonadOxide.none()
          .inspect_some() { 'bar' }
          .none?()
      ).to(be(true))
    end

  end

  context '#inspect_none' do

    context 'with blocks' do
      it 'calls the block and returns the same None' do
        ran = false
        result = MonadOxide.none()
          .inspect_none() { ran = true }
        expect(ran).to(be(true))
      end

      it 'returns the original None' do
        expect(
          MonadOxide.none()
            .inspect_none() { 'bar' }
            .none?()
        ).to(be(true))
      end
    end

    context 'with Procs' do
      it 'calls the function and returns the same None' do
        ran = false
        result = MonadOxide.none()
          .inspect_none(->() { ran = true })
        expect(ran).to(be(true))
      end

      it 'returns the original None' do
        expect(
          MonadOxide.none()
            .inspect_none(->() { 'bar' })
            .none?()
        ).to(be(true))
      end
    end

  end

  context '#map' do

    it 'falls through and returns the None' do
      expect(
        MonadOxide.none()
          .map() { 'bar' }
          .none?()
      ).to(be(true))
    end

  end

  context '#map_none' do

    context 'with blocks' do
      it 'calls the block and returns a new Some' do
        expect(
          MonadOxide.none()
            .map_none() { 'bar' }
            .unwrap()
        ).to(eq('bar'))
      end
    end

    context 'with Procs' do
      it 'calls the function and returns a new Some' do
        expect(
          MonadOxide.none()
            .map_none(->() { 'bar' })
            .unwrap()
        ).to(eq('bar'))
      end
    end

  end

  context '#none?' do

    it 'returns true for None' do
      expect(MonadOxide.none().none?()).to(be(true))
    end

  end

  context '#or_else' do

    context 'with blocks' do
      it 'calls the block and returns the Option returned' do
        expect(
          MonadOxide.none()
            .or_else() { MonadOxide.some('bar') }
            .unwrap()
        ).to(eq('bar'))
      end

      it 'raises OptionReturnExpectedError if block returns non-Option' do
        expect {
          MonadOxide.none()
            .or_else() { 'bar' }
        }.to(raise_error(MonadOxide::OptionReturnExpectedError))
      end

      it 'returns the same None returned by the block' do
        expect(
          MonadOxide.none()
            .or_else() { MonadOxide.none() }
            .none?()
        ).to(be(true))
      end
    end

    context 'with Procs' do
      it 'calls the function and returns the Option returned' do
        expect(
          MonadOxide.none()
            .or_else(->() { MonadOxide.some('bar') })
            .unwrap()
        ).to(eq('bar'))
      end

      it 'raises OptionReturnExpectedError if function returns non-Option' do
        expect {
          MonadOxide.none()
            .or_else(->() { 'bar' })
        }.to(raise_error(MonadOxide::OptionReturnExpectedError))
      end

      it 'returns the same None returned by the function' do
        expect(
          MonadOxide.none()
            .or_else(->() { MonadOxide.none() })
            .none?()
        ).to(be(true))
      end
    end

  end

  context '#some?' do

    it 'returns false for None' do
      expect(MonadOxide.none().some?()).to(be(false))
    end

  end

  context '#unwrap' do

    it 'raises UnwrapError for None' do
      expect {
        MonadOxide.none().unwrap()
      }.to(raise_error(MonadOxide::UnwrapError))
    end

  end

  context '#unwrap_none' do

    it 'returns nil for None' do
      expect(MonadOxide.none().unwrap_none()).to(be_nil())
    end

  end

end
