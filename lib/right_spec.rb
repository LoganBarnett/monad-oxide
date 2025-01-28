# frozen_string_literal: true

require 'monad-oxide'

describe MonadOxide::Right do

  context '#right_and_then' do

    context 'with blocks' do

      it 'passes the data from the Right to the block' do
        expect(
          MonadOxide.right('foo')
            .right_and_then() { |s| MonadOxide.right(s + 'bar') }
            .unwrap_right()
        ).to(eq('foobar'))
      end

      it 'raises an error if the block returns a non-Either' do
        expect() {
          MonadOxide.right('foo')
            .right_and_then() {|_| 'bar' }
            .unwrap_right()
        }.to(raise_error(MonadOxide::EitherReturnExpectedError))
      end

      it 'returns the same Right returned by the block' do
        expect(
          MonadOxide.right('foo')
            .right_and_then() {|_| MonadOxide.right('bar') }
            .unwrap_right()
        ).to(eq('bar'))
      end

      it 'returns the same Left returned by the block' do
        expect(
          MonadOxide.right('foo')
            .right_and_then() {|_| MonadOxide.left('bar') }
            .unwrap_left()
        ).to(eq('bar'))
      end

    end

    context 'with Procs' do

      it 'passes the data from the Right to the Proc' do
        expect(
          MonadOxide.right('foo')
            .right_and_then(->(s) { MonadOxide.right(s + 'bar') })
            .unwrap_right()
        ).to(eq('foobar'))
      end

      it 'raises an error if the Proc returns a non-Either' do
        expect() {
          MonadOxide.right('foo')
            .right_and_then(->(_) { 'bar' })
            .unwrap_right()
        }.to(raise_error(MonadOxide::EitherReturnExpectedError))
      end

      it 'returns the same Right returned by the Proc' do
        expect(
          MonadOxide.right('foo')
            .right_and_then(->(_) { MonadOxide.right('bar') })
            .unwrap_right()
        ).to(eq('bar'))
      end

      it 'returns the same Left returned by the Proc' do
        expect(
          MonadOxide.right('foo')
            .right_and_then(->(_) { MonadOxide.left('bar') })
            .unwrap_left()
        ).to(eq('bar'))
      end

    end

    context '#right?' do
      it 'is a Right' do
        expect(MonadOxide.right('foo')).to(be_right())
      end
    end

    context '#left?' do
      it 'is not a Left' do
        expect(MonadOxide.right('foo')).not_to(be_left())
      end
    end

    context('#inspect_right') {

      context('with a Proc') {

        it('applies the data to the Proc provided') {
          effected = 'unset'
          MonadOxide
            .right('foo')
            .inspect_right(->(s) { effected = "effect: #{s}" })
          expect(effected).to(eq('effect: foo'))
        }

        it('does not change the underlying data') {
          expect(
            MonadOxide
              .right('foo')
              .inspect_right(->(_) { 'bar' })
              .unwrap_right()
          ).to(eq('foo'))
        }

      }

      context('with a block') {

        it('applies the data to the Proc provided') {
          effected = 'unset'
          MonadOxide.right('foo')
            .inspect_right() { |s| effected = "effect: #{s}" }
          expect(effected).to(eq('effect: foo'))
        }

        it('does not change the underlying data') {
          expect(
            MonadOxide
              .right('foo')
              .inspect_right() { |_| 'bar' }
              .unwrap_right()
          ).to(eq('foo'))
        }

      }

    }

    context('#inspect_left') {

      context('with a Proc') {

        it('does not execute the function provided') {
          effect = 'unset'
          expect(
            MonadOxide
              .right('foo')
              .inspect_left(->(_) { effect = 'bar' })
              .unwrap_right()
          ).to(eq('foo'))
        }

        it('does not execute the function provided') {
          effect = 'unset'
          MonadOxide
            .right('foo')
            .inspect_left(->(_) { effect = 'bar' })
          expect(effect).to(eq('unset'))
        }

      }

      context('with a block') {

        it('returns the Right with the original value') {
          expect(
            MonadOxide
              .right('foo')
              .inspect_left() { |_| 'bar' }
              .unwrap_right()
          ).to(eq('foo'))
        }

        it('does not execute the function provided') {
          effect = 'unset'
          MonadOxide
            .right('foo')
            .inspect_left() { |_| effect = 'bar' }
          expect(effect).to(eq('unset'))
        }

      }

    }

    context('#left_and_then') {

      context('with a Proc') {

        it('does not execute the function provided') {
          expect(
            MonadOxide
              .right('foo')
              .left_and_then(->(_) { 'bar' })
              .unwrap_right()
          ).to(eq('foo'))
        }

      }

      context('with a block') {

        it('does not execute the function provided') {
          expect(
            MonadOxide
              .right('foo')
              .left_and_then() { 'bar' }
              .unwrap_right()
          ).to(eq('foo'))
        }

      }

    }

  end

  context '#match' do

    it 'returns the Right branch proc\'s value' do
      expect(
        MonadOxide
          .right(StandardError.new('foo'))
          .match({
            MonadOxide::Left => ->(_x) { 'bar' },
            MonadOxide::Right => ->(_x) { 'error' },
          })
      ).to(eq('error'))
    end

    it 'operates on the Right\'s value' do
      expect(
        MonadOxide
          .right(StandardError.new('foo'))
          .match({
            MonadOxide::Left => ->(_x) { 'bar' },
            MonadOxide::Right => ->(x) { "#{x.to_s()}-error" },
          })
      ).to(eq('foo-error'))
    end

  end

end
