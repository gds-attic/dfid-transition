shared_examples 'holds onto the location of a schema file and warns us if it is not there' do
  let(:patcher) { described_class.new(patch_location) }
  let(:patch_location) { nil }

  describe '#mutate_schema' do
    it 'implements mutate schema' do
      expect(patcher).to respond_to(:mutate_schema)
    end
  end

  describe '#location' do
    let(:patch_location) { nil }

    it 'defaults to a location' do
      expect(patcher.location).not_to be_nil
    end

    context 'a schema file could not be found' do
      let(:patch_location) { 'spec/fixtures/schemas/unknown.json' }

      it 'tells us so' do
        expect { patcher.run }.to raise_error(
          Errno::ENOENT, /unknown\.json/)
      end
    end

    context 'a schema location is supplied' do
      let(:patch_location) { 'spec/fixtures/patchme.json' }

      it 'patches that location' do
        expect(patcher.location).to eq(patch_location)
      end
    end
  end
end
