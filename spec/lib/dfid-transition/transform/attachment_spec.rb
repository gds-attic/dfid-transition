 require 'spec_helper'
require 'dfid-transition/transform/attachment'

module DfidTransition::Transform
  describe Attachment do
    subject(:attachment) { Attachment.new(original_url) }

    context 'nothing usable is given' do
      it 'fails given completely the wrong type' do
        expect { Attachment.new(1) }.to raise_error(ArgumentError, /expected URI object or URI string/)
      end
      it 'fails given a URI that isn\'t a URL' do
        expect { Attachment.new('some:uri') }.to raise_error(ArgumentError, /expected a URL/)
      end
    end

    describe '#hosted_at_r4d?' do
      subject { attachment.hosted_at_r4d? }

      context 'given a URL that is offsite' do
        let(:original_url) { 'http://example.com/offsite' }
        it { is_expected.to be false }
      end

      context 'given a URL that is onsite' do
        let(:original_url) { 'http://r4d.dfid.gov.uk/some/file.pdf' }
        it { is_expected.to be true }
      end
    end

    describe '#filename' do
      context 'a filename with an extension' do
        let(:original_url) { 'http://example.com/some/path/title_of_the_file.pdf' }
        it 'uses the filename' do
          expect(attachment.filename).to eql('title_of_the_file.pdf')
        end
      end

      context 'a path but no extension' do
        let(:original_url) { 'http://example.com/some/path/' }
        it 'uses the last part of the path' do
          expect(attachment.filename).to eql('path')
        end
      end

      context 'no path at all' do
        let(:original_url) { 'http://example.com/' }
        example { expect(attachment.filename).to be_empty }
      end
    end

    describe '#content_id' do
      let(:original_url) { 'http://r4d.dfid.gov.uk/pdfs/some.pdf' }
      let(:uuid) { /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }

      it 'is a uuid' do
        expect(attachment.content_id).to match uuid
      end

      it 'is only minted once' do
        expect(attachment.content_id).to eql(attachment.content_id)
      end
    end

    describe '#snippet' do
      subject { attachment.snippet }

      context 'it is hosted at r4d' do
        let(:original_url) { 'http://r4d.dfid.gov.uk/some/file.pdf' }
        it { is_expected.to eql('[InlineAttachment:file.pdf]') }
      end
      context 'it is hosted offsite' do
        let(:original_url) { 'http://www.example.com/some/file.pdf' }
        it { is_expected.to eql('[file.pdf](http://www.example.com/some/file.pdf)') }
      end
    end

    describe '#file_future' do
      subject { attachment.file_future }

      context 'an offsite URL' do
        let(:original_url) { 'http://example.com/1234' }
        it { is_expected.to be_a(Concurrent::Future) }

        it 'has a value of false' do
          expect(attachment.file).to be false
        end
      end
      context 'an onsite URL' do
        let(:original_url) { 'http://r4d.dfid.gov.uk/pdfs/some.pdf' }
        let(:pdf_content) { 'This is PDF content, honest' }

        before do
          stub_request(:get, original_url).to_return(body: pdf_content)
        end

        it { is_expected.to be_a(Concurrent::Future) }

        it 'has the content of the PDF as a File' do
          expect(attachment.file).to be_a(File)
          expect(attachment.file.read).to eql(pdf_content)
        end
      end
    end
  end
end
