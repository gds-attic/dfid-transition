require 'spec_helper'
require 'dfid-transition/patch/specialist_publisher/document_types'
require 'rdf/rdfxml'

describe DfidTransition::Patch::SpecialistPublisher::DocumentTypes do
  let(:patch_location) { nil }
  subject(:patch) { DfidTransition::Patch::SpecialistPublisher::DocumentTypes.new(patch_location) }

  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#run' do
    let(:patch_location) { 'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs.json' }
    let(:r4d_skos_document_type_repo) do
      RDF::Repository.load('spec/fixtures/service-results/r4d_skos_document_types.rdf')
    end

    before do
      allow(patch).to receive(:document_types_query).and_return(
        DfidTransition::Extract::Query::DocumentTypes.new(
          SPARQL::Client.new(r4d_skos_document_type_repo)
        )
      )

      FileUtils.cp(
        'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs_src.json',
        patch_location)

      patch.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }
    let(:document_types) { schema['facets'].find { |facet| facet['key'] == 'dfid_document_type' } }

    subject(:allowed_values) { document_types['allowed_values'] }

    it 'adds document_type data to the schema' do
      expect(allowed_values.count).to eq(66)
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
