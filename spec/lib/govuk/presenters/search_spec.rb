require 'spec_helper'
require 'govuk/presenters/search'

describe Govuk::Presenters::Search do
  subject(:presenter) { Govuk::Presenters::Search.new(document) }

  context 'a document and publishing API are given' do
    let(:document) do
      double(
        'DfidTransition::Transform::Document',
        title: 'A Title',
        summary: 'A summary',
        base_path: '/dfid-research-outputs/a-title',
        public_updated_at: '2016-05-12 09:21:23+00:00',
        body: '## A Title',
        format_specific_metadata: { country: ['GB'], blank_value: '' }
      )
    end

    describe '#indexable_content' do
      it 'indexes the govspeak' do
        expect(presenter.indexable_content).to eql('## A Title')
      end
    end

    describe '#to_json' do
      subject(:json) { presenter.to_json }

      it 'has a title' do
        expect(json[:title]).to eql('A Title')
      end

      it 'has its link as the base_path' do
        expect(json[:link]).to eql(document.base_path)
      end

      it 'makes public_timestamp RFC3339' do
        # Basically, adds a 'T' ...
        expect(json[:public_timestamp]).to eql('2016-05-12T09:21:23+00:00')
      end

      it 'fixes organisations to just DFID' do
        expect(json[:organisations]).to eql(['department-for-international-development'])
      end

      it 'includes format-specific metadata' do
        expect(json[:country]).to eql(['GB'])
      end

      it 'has no blank values' do
        expect(json[:blank_value]).to be_nil
      end
    end
  end
end
