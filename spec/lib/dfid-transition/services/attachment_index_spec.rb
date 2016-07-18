require 'spec_helper'
require 'dfid-transition/services/attachment_index'
require 'mock_redis'

describe DfidTransition::Services::AttachmentIndex do
  AttachmentIndex = DfidTransition::Services::AttachmentIndex

  let(:redis) { MockRedis.new }
  subject(:attachment_index) { AttachmentIndex.new(redis) }

  let(:original_url) { 'http://example.com/a.pdf' }

  let(:asset_response) do
    double(
      'GDSApi::Response',
      '_response_info' => { 'status' => 'created' },
      'id' => 'http://asset-manager.dev.gov.uk/assets/5788a087759b74360900006c',
      'name' => 'a.pdf',
      'content_type' => 'application/pdf',
      'file_url' => 'http://assets-origin.dev.gov.uk/media/5788a087759b74360900006c/60953_DV_Law_Prelim_Report_2014.pdf',
      'state' => 'unscanned'
    )
  end

  describe '.put' do
    context 'an original_url and an asset response is given' do
      before { @response = attachment_index.put(original_url, asset_response) }

      it 'writes multiply OK, true' do
        expect(@response).to eql(['OK', true])
      end

      it 'adds to the dfid-transition-known-attachments hash' do
        expect(redis.smembers(AttachmentIndex::KNOWN_ATTACHMENTS_KEY)).to eql([original_url])
      end
    end
  end

  describe '.get' do
    context 'there is no item in the index' do
      it 'returns nil' do
        expect(attachment_index.get('http://example.com/i.dont.exist.pdf')).to eql(nil)
      end
    end

    context 'there is an item in the index' do
      before do
        attachment_index.put(original_url, asset_response)
      end

      subject(:attachment_status) do
        attachment_index.get(original_url)
      end

      describe 'The returned attachment status' do
        it 'has an original_url' do
          expect(attachment_status['original_url']).to eql(original_url)
        end

        it 'has the asset manager url' do
          expect(attachment_status['asset_manager_url']).to eql(asset_response.id)
        end
      end
    end
  end
end
