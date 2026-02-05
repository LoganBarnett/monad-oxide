# frozen_string_literal: true
require 'monad-oxide'

describe MonadOxide::Result do
  context '#initialize' do
    it 'is protected from external consumption' do
      expect { MonadOxide::Result.new('hi') }.to(raise_exception(NoMethodError))
    end
  end

  context '#flatten' do
    it 'returns itself when the Result is already flat' do
      r = MonadOxide.ok('flat')
      expect(r.flatten()).to(be(r))
    end

    it 'returns the inner result' do
      inner = MonadOxide.ok('inner')
      outer = MonadOxide.ok(inner)
      expect(outer.flatten()).to(be(inner))
    end

    it 'returns the innermost result regardless of nesting' do
      innermost = MonadOxide.ok('innermost')
      inner = MonadOxide.ok(innermost)
      outer = MonadOxide.ok(inner)
      expect(outer.flatten()).to(be(innermost))
    end
  end

  describe('.try') {

    context('with lambdas') {

      it('converts a successful outcome into an Ok') {
        r = MonadOxide::Result.try(->() {
          return 0
        })
        expect(r).to(be_ok())
      }

      it('wraps the return value in the Ok') {
        r = MonadOxide::Result.try(->() {
          return 0
        })
        expect(r.unwrap()).to(be(0))
      }

      it('converts a raised error in to an Err') {
        r = MonadOxide::Result.try(->() {
          raise StandardError.new('foo')
        })
        expect(r).to(be_err())
      }

      it('wraps the raised error in the Err') {
        r = MonadOxide::Result.try(->() {
          raise StandardError.new('foo')
        })
        expect(r.unwrap_err().message()).to(eq('foo'))
      }

    }

    context('with blocks') {

      it('converts a successful outcome into an Ok') {
        r = MonadOxide::Result.try() {
          next 0
        }
        expect(r.unwrap()).to(be(0))
      }

      it('wraps the return value in the Ok') {
        r = MonadOxide::Result.try() {
          next 0
        }
        expect(r.unwrap()).to(be(0))
      }

      it('converts a raised error in to an Err') {
        r = MonadOxide::Result.try() {
          raise StandardError.new('foo')
        }
        expect(r).to(be_err())
      }

      it('wraps the raised error in the Err') {
        r = MonadOxide::Result.try() {
          raise StandardError.new('foo')
        }
        expect(r.unwrap_err().message()).to(eq('foo'))
      }

    }

  }
end
