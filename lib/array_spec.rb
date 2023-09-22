describe Array do

  context '#into_result' do

    context 'all Oks' do

      it 'returns a single Ok' do
        result = [
          MonadOxide.ok('foo'),
          MonadOxide.ok('bar'),
          MonadOxide.ok('baz'),
        ].into_result()
        expect(result).to(be_a_kind_of(MonadOxide::Ok))
      end

      it 'returns a single Ok that has an array of Ok data' do
        result = [
          MonadOxide.ok('foo'),
          MonadOxide.ok('bar'),
          MonadOxide.ok('baz'),
        ].into_result()
        expect(result.unwrap()).to(eq(['foo', 'bar', 'baz']))
      end

    end

    context 'all Errs' do

      it 'returns a single Err' do
        result = [
          MonadOxide.err(StandardError.new('foo')),
          MonadOxide.err(StandardError.new('bar')),
          MonadOxide.err(StandardError.new('baz')),
        ].into_result()
        expect(result).to(be_a_kind_of(MonadOxide::Err))
      end

      it 'returns a single Err that has an array of Err data' do
        result = [
          MonadOxide.err(StandardError.new('foo')),
          MonadOxide.err(StandardError.new('bar')),
          MonadOxide.err(StandardError.new('baz')),
        ].into_result()
        expect(result.unwrap_err().map(&:message)).to(eq(['foo', 'bar', 'baz']))
      end

    end

    context 'mixed Oks and Errs' do

      it 'returns a single Err' do
        result = [
          MonadOxide.ok('foo'),
          MonadOxide.err(StandardError.new('bar')),
          MonadOxide.ok('baz'),
        ].into_result()
        expect(result).to(be_a_kind_of(MonadOxide::Err))
      end

      it 'returns a single Err that has an array of Err data' do
        result = [
          MonadOxide.err(StandardError.new('foo')),
          MonadOxide.err(StandardError.new('bar')),
          MonadOxide.ok('baz'),
        ].into_result()
        expect(result.unwrap_err().map(&:message)).to(eq(['foo', 'bar']))
      end

      it 'returns a single Err that has no Ok data' do
        result = [
          MonadOxide.err(StandardError.new('foo')),
          MonadOxide.err(StandardError.new('bar')),
          MonadOxide.ok('baz'),
        ].into_result()
        expect(result.unwrap_err().map(&:message)).not_to(include('baz'))
      end
    end

  end

end
