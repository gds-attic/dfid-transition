require 'spec_helper'
require 'dfid-transition/extract/download/attachment'

describe DfidTransition::Extract::Download::Attachment do
  describe '#perform' do
    let(:attachment_index) { spy 'DfidTransition::Extract::Transform::AttachmentIndex' }
    let(:logger)           { spy 'Logger' }
    let(:asset_manager)    { spy 'GdsApi::AssetManager' }
    let(:original_url)     { 'http://r4d.dfid.gov.uk/file.pdf' }

    before do
      allow(subject).to receive(:asset_manager).and_return(asset_manager)
      allow(subject).to receive(:attachment_index).and_return(attachment_index)
      allow(subject).to receive(:logger).and_return(logger)
    end

    context 'the URL is already in the index' do
      before do
        allow(attachment_index).to receive(:get).with(original_url).and_return(totally: 'exists')

        subject.perform(original_url)
      end

      it 'logs that it is skipping' do
        expect(logger).to have_received(:info).with("Skipping: #{original_url}")
      end

      it 'does nothing else' do
        expect(asset_manager).not_to have_received(:create_asset)
      end
    end

    context 'the URL is not in the index and we can download it ok' do
      let(:asset_response) { double 'Hash' }

      before do
        allow(attachment_index).to receive(:get).with(original_url).and_return(nil)
        stub_request(:get, original_url).to_return(status: 200, body: 'Some content')
        allow(asset_manager).to receive(:create_asset).and_return(asset_response)
        allow(File).to receive(:delete)

        subject.perform(original_url)
      end

      it 'uploads to asset manager' do
        expect(asset_manager).to have_received(:create_asset).with(file: instance_of(File))
      end

      it 'updates the index' do
        expect(attachment_index).to have_received(:put).with(original_url, asset_response)
      end

      it 'cleans up the file afterwards' do
        expect(File).to have_received(:delete).with('/tmp/file.pdf')
      end
    end
  end
end
