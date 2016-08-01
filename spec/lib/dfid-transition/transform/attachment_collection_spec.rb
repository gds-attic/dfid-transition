require 'spec_helper'
require 'dfid-transition/transform/attachment_collection'

module DfidTransition::Transform
  describe AttachmentCollection do
    subject(:attachments) { AttachmentCollection.from_uris(uris) }

    describe '.from_uris' do
      context 'nothing usable is given' do
        it 'fails given completely the wrong type' do
          expect { AttachmentCollection.from_uris(1) }.to raise_error(ArgumentError, /Expected space-separated string/)
        end
      end

      context 'something usable is given' do
        let(:uris) { 'http://example.com/1.pdf http://example.com/2.pdf' }

        it 'it creates a collection of Attachment' do
          expect(attachments).to be_an(AttachmentCollection)
          expect(attachments.first).to be_an(Attachment)
          expect(attachments.count).to eql(2)
        end
      end
    end

    describe '#downloads' do
      let(:uris) { 'http://example.com/offsite.pdf http://r4d.dfid.gov.uk/pdf/outputs/onsite.pdf' }

      subject(:downloads) { attachments.downloads }

      it 'filters the downloads' do
        expect(attachments.count).to eql(2)
        expect(downloads.count).to eql(1)
      end
    end

    describe '.normalize!' do
      let(:document_title) { 'And then he switched off the mobile phone' }

      before { attachments.normalize!(document_title) }

      context 'there is a single offsite' do
        let(:uris) { 'http://example.com/1' }

        it 'has set the title' do
          expect(attachments.first.title).to eql(document_title)
        end
      end

      context 'there is a single onsite' do
        let(:uris) { 'http://r4d.dfid.gov.uk/some.pdf' }

        it 'has set the title' do
          expect(attachments.first.title).to eql(document_title)
        end
      end

      context 'there is one offsite and one onsite for different things' do
        let(:uris) { 'http://example.com/1.pdf http://r4d.dfid.gov.uk/2.pdf' }

        it 'leaves the titles alone' do
          attachments_array = attachments.to_a

          expect(attachments_array.first.title).to eql('1.pdf')
          expect(attachments_array.last.title).to eql('2.pdf')
        end
      end

      context 'there is one offsite on dxdoi.org for the same thing as one PDF' do
        let(:uris) { 'http://dx.doi.org/BUMPH http://r4d.dfid.gov.uk/2.pdf' }

        it 'removes dx.doi.org' do
          expect(attachments.count).to eql(1)
          expect(attachments.first.original_url.to_s).to match(/r4d/)
        end

        it 'sets the remaining r4d attachment title to document title' do
          expect(attachments.first.title).to eql(document_title)
        end
      end

    end
  end
end
