require 'monad-oxide'
require 'result'

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
end
