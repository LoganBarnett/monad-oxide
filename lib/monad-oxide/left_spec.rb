# frozen_string_literal: true

require 'monad-oxide'

describe MonadOxide::Left do

  context '#left_and_then' do

    context 'with blocks' do

      it 'passes the data from the Left to the block' do
        expect(
          MonadOxide.left('foo')
            .left_and_then() { |s| MonadOxide.left(s + 'bar') }
            .unwrap_left()
        ).to(eq('foobar'))
      end

      it 'raises an error if the block returns a non-Either' do
        expect() {
          MonadOxide.left('foo')
            .left_and_then() {|_| 'bar' }
            .unwrap_left()
        }.to(raise_error(MonadOxide::EitherReturnExpectedError))
      end

      it 'returns the same Left returned by the block' do
        expect(
          MonadOxide.left('foo')
            .left_and_then() {|_| MonadOxide.left('bar') }
            .unwrap_left()
        ).to(eq('bar'))
      end

      it 'returns the same Right returned by the block' do
        expect(
          MonadOxide.left('foo')
            .left_and_then() {|_| MonadOxide.right('bar') }
            .unwrap_right()
        ).to(eq('bar'))
      end

    end

    context 'with Procs' do

      it 'passes the data from the Left to the Proc' do
        expect(
          MonadOxide.left('foo')
            .left_and_then(->(s) { MonadOxide.left(s + 'bar') })
            .unwrap_left()
        ).to(eq('foobar'))
      end

      it 'raises an error if the Proc returns a non-Either' do
        expect() {
          MonadOxide.left('foo')
            .left_and_then(->(_) { 'bar' })
            .unwrap_left()
        }.to(raise_error(MonadOxide::EitherReturnExpectedError))
      end

      it 'returns the same Left returned by the Proc' do
        expect(
          MonadOxide.left('foo')
            .left_and_then(->(_) { MonadOxide.left('bar') })
            .unwrap_left()
        ).to(eq('bar'))
      end

      it 'returns the same Right returned by the Proc' do
        expect(
          MonadOxide.left('foo')
            .left_and_then(->(_) { MonadOxide.right('bar') })
            .unwrap_right()
        ).to(eq('bar'))
      end

    end

    context '#left?' do
      it 'is a Left' do
        expect(MonadOxide.left('foo')).to(be_left())
      end
    end

    context '#right?' do
      it 'is not a Right' do
        expect(MonadOxide.left('foo')).not_to(be_right())
      end
    end

    context('#inspect_left') {

      context('with a Proc') {

        it('applies the data to the Proc provided') {
          effected = 'unset'
          MonadOxide
            .left('foo')
            .inspect_left(->(s) { effected = "effect: #{s}" })
          expect(effected).to(eq('effect: foo'))
        }

        it('does not change the underlying data') {
          expect(
            MonadOxide
              .left('foo')
              .inspect_left(->(_) { 'bar' })
              .unwrap_left()
          ).to(eq('foo'))
        }

      }

      context('with a block') {

        it('applies the data to the Proc provided') {
          effected = 'unset'
          MonadOxide.left('foo')
            .inspect_left() { |s| effected = "effect: #{s}" }
          expect(effected).to(eq('effect: foo'))
        }

        it('does not change the underlying data') {
          expect(
            MonadOxide
              .left('foo')
              .inspect_left() { |_| 'bar' }
              .unwrap_left()
          ).to(eq('foo'))
        }

      }

    }

    context('#inspect_right') {

      context('with a Proc') {

        it('does not execute the function provided') {
          effect = 'unset'
          expect(
            MonadOxide
              .left('foo')
              .inspect_right(->(_) { effect = 'bar' })
              .unwrap_left()
          ).to(eq('foo'))
        }

        it('does not execute the function provided') {
          effect = 'unset'
          MonadOxide
            .left('foo')
            .inspect_right(->(_) { effect = 'bar' })
          expect(effect).to(eq('unset'))
        }

      }

      context('with a block') {

        it('returns the Left with the original value') {
          expect(
            MonadOxide
              .left('foo')
              .inspect_right() { |_| 'bar' }
              .unwrap_left()
          ).to(eq('foo'))
        }

        it('does not execute the function provided') {
          effect = 'unset'
          MonadOxide
            .left('foo')
            .inspect_right() { |_| effect = 'bar' }
          expect(effect).to(eq('unset'))
        }

      }

    }

    context('#right_and_then') {

      context('with a Proc') {

        it('does not execute the function provided') {
          expect(
            MonadOxide
              .left('foo')
              .right_and_then(->(_) { 'bar' })
              .unwrap_left()
          ).to(eq('foo'))
        }

      }

      context('with a block') {

        it('does not execute the function provided') {
          expect(
            MonadOxide
              .left('foo')
              .right_and_then() { 'bar' }
              .unwrap_left()
          ).to(eq('foo'))
        }

      }

    }

  end

  context '#match' do

    it 'returns the Left branch proc\'s value' do
      expect(
        MonadOxide
          .left('foo')
          .match({
            MonadOxide::Left => ->(_x) { 'bar' },
            MonadOxide::Right => ->(_x) { 'error' },
          })
      ).to(eq('bar'))
    end

    it 'operates on the Left\'s value' do
      expect(
        MonadOxide
          .left('foo')
          .match({
            MonadOxide::Left => ->(x) { "#{x}bar" },
            MonadOxide::Right => ->(_x) { 'error' },
          })
      ).to(eq('foobar'))
    end

  end

end
