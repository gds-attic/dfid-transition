require 'spec_helper'
require 'dfid-transition/patch/specialist_publisher/document_types'

describe DfidTransition::Patch::SpecialistPublisher::DocumentTypes do
  let(:patch_location) { nil }

  subject(:patcher) { DfidTransition::Patch::SpecialistPublisher::DocumentTypes.new(patch_location) }

  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#run' do
    include_examples 'fake document types'

    let(:patch_location) { 'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs.json' }

    before do
      allow(patcher).to receive(:document_types_query).and_return(fake_document_types)

      FileUtils.cp(
        'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs_src.json',
        patch_location)

      patcher.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }
    let(:document_types) { schema['facets'].find { |facet| facet['key'] == 'dfid_document_type' } }

    subject(:allowed_values) { document_types['allowed_values'] }

    it 'adds document_type data to the schema' do
      expect(allowed_values.count).to eq(document_type_solutions.size)
    end

    it 'leaves labels alone and underscores/downcases values' do
      expect(allowed_values).to include(
        'label' => 'Magazine/Newsletter/Newspaper Article',
        'value' => 'magazine_newsletter_newspaper_article'
      )
    end

    it 'sorts document_types alphabetically by label' do
      labels = document_types['allowed_values'].map { |lv| lv['label'] }
      expect(labels).to eql(labels.sort), 'document_type labels are not sorted'
    end
  end
end
