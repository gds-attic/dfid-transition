require 'spec_helper'
require 'dfid-transition/load/outputs'
require 'gds_api/exceptions'

describe DfidTransition::Load::Outputs do
  let(:publishing_api) { spy('publishing-api') }
  let(:rummager)       { spy('rummager') }
  let(:asset_manager)  { spy('asset_manager') }
  let(:solutions)      { [] }
  let(:null_logger)    { double('Logger').as_null_object }

  subject(:loader) do
    DfidTransition::Load::Outputs.new(
      publishing_api, rummager, asset_manager, solutions, logger: null_logger
    )
  end

  describe '#run' do
    include RDFDoubles

    let(:solutions)   { [solution_hash] }
    let(:solution)    { double('RDF::Query::Solution') }
    let(:onsite_pdf)  { 'http://r4d.dfid.gov.uk/pdfs/onsite.pdf' }
    let(:offsite_pdf) { 'http://example.com/offsite.pdf' }
    let(:solution_hash) do
      {
        output:       uri('http://original_url/1234/'),
        date:         literal('2016-04-28T09:52:00'),
        title:        literal('Output Title'),
        abstract:     literal('&amp;lt;p&amp;gt;Abstract;lt;/p&amp;gt;'),
        countryCodes: literal('AZ GB'),
        uris:         literal("#{onsite_pdf} #{offsite_pdf}")
      }
    end
    let(:asset_response) do
      OpenStruct.new file_url: 'http://some.media.link/1234567'
    end
    let(:uuid) { /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
    let(:existing_content_id) { nil }

    before do
      allow(solution).to receive(:[]) { |key| solution_hash[key] }
      allow(publishing_api).to receive(:lookup_content_id).and_return(existing_content_id)
      stub_request(:get, onsite_pdf).to_return(body: 'This is PDF content, honest')
      allow(asset_manager).to receive(:create_asset).with(file: instance_of(File)).and_return(asset_response)
    end

    after do
      loader.send(:documents).each do |document|
        document.downloads.each { |download| File.delete("/tmp/#{download.filename}") }
      end
    end

    context 'there is one good solution and no pre-existing content' do
      before { loader.run }

      it 'stores the PDF in the asset_manager' do
        expect(asset_manager).to have_received(:create_asset).with(file: instance_of(File))
      end

      it 'puts the content' do
        expect(publishing_api).to have_received(:put_content).with(
          uuid, instance_of(Hash)
        )
      end

      it 'publishes the content as major' do
        expect(publishing_api).to have_received(:publish).with(uuid, 'major')
      end

      it 'sends the organisation in a call to links' do
        expect(publishing_api).to have_received(:patch_links).with(
          uuid,
          links: {
            organisations: [instance_of(String)]
          },
        )
      end

      it 'adds the document to rummager' do
        expect(rummager).to have_received(:add_document).with(
          'dfid_research_output',
          instance_of(String),
          instance_of(Hash)
        )
      end
    end

    context 'there is one good solution and a pre-existing document' do
      let(:existing_content_id) { '9f050fc0-9222-4cf5-a74c-f9634b9b26ee' }

      before { loader.run }

      it 'republishes the content' do
        expect(publishing_api).to have_received(:publish).with(existing_content_id, 'republish')
      end
    end

    context 'publishing the solution fails on publish' do
      let(:publishing_api) { double('publishing_api') }

      before do
        allow(publishing_api).to receive(:put_content)
        allow(publishing_api).to receive(:patch_links)
        allow(publishing_api).to receive(:publish).and_raise(
          GdsApi::HTTPUnprocessableEntity.new(422, 'Something went bang when we tried to publish'))
        allow(publishing_api).to receive(:discard_draft)

        loader.run
      end

      it 'discards the draft' do
        expect(publishing_api).to have_received(:discard_draft)
      end
    end
  end
end
