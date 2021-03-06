require 'spec_helper'
require 'dfid-transition/transform/attachment'

module DfidTransition::Transform
  describe Attachment do
    subject(:attachment) { Attachment.new(original_url) }

    context 'nothing usable is given' do
      it 'fails given completely the wrong type' do
        expect { Attachment.new(1) }.to raise_error(ArgumentError, /expected URI object or URI string/)
      end
      it 'fails given a URI that isn\'t a URL in our schemes' do
        expect { Attachment.new('some:uri') }.to raise_error(ArgumentError, /expected an HTTP or FTP URL/)
      end
    end

    context 'given an offsite URL' do
      let(:original_url) { 'http://example.com/some/file.pdf' }

      it 'is not #hosted_at_r4d?' do
        expect(attachment.hosted_at_r4d?).to be false
      end

      it 'is an #external_link?' do
        expect(attachment.external_link?).to be true
      end

      it 'has an external link as a #snippet' do
        expect(attachment.snippet).to eql('[file.pdf](http://example.com/some/file.pdf)')
      end

      context 'the title is set' do
        before { attachment.title = 'Zootopia' }
        it 'renders the title in the #snippet' do
          expect(attachment.snippet).to eql('[Zootopia](http://example.com/some/file.pdf)')
        end
      end

      describe '#to_json' do
        it 'is never called for an external link' do
          expect { attachment.to_json }.to raise_error(
            RuntimeError, '#to_json is not valid for an external link')
        end
      end

      describe '#file and #file_future' do
        it 'has no Future at all' do
          expect { attachment.file_future }.to raise_error(RuntimeError, 'external links cannot be downloaded')
          expect { attachment.file }.to        raise_error(RuntimeError, 'external links cannot be downloaded')
        end
      end
    end

    context 'given an onsite URL' do
      let(:original_url) { 'http://r4d.dfid.gov.uk/some/file.pdf' }

      it 'is #hosted_at_r4d?' do
        expect(attachment.hosted_at_r4d?).to be true
      end

      it 'is not an #external_link?' do
        expect(attachment.external_link?).to be false
      end

      it 'has an InlineAttachment #snippet' do
        expect(attachment.snippet).to eql('[InlineAttachment:file.pdf]')
      end

      describe '#details_from_index' do
        it 'allows the mocking of the asset response' do
          details_from_index = {
            'file_url' => 'http://some.url'
          }
          attachment.details_from_index(details_from_index)
          asset_response = attachment.send(:asset_response)

          expect(asset_response.file_url).to eql('http://some.url')
        end
      end

      describe '#to_json' do
        before do
          allow(attachment).to receive(:asset_response).and_return(
            double('response', file_url: 'http://asset.url'))
        end

        it 'has the asset manager url' do
          expect(attachment.to_json[:url]).to eql('http://asset.url')
        end

        describe '[:content_type]' do
          context 'for a PDF' do
            example { expect(attachment.to_json[:content_type]).to eql('application/pdf') }
          end
          context 'for a JPEG' do
            let(:original_url) { 'http://r4d.dfid.gov.uk/a.jpg' }
            example { expect(attachment.to_json[:content_type]).to eql('image/jpeg') }
          end
          context 'for nothing in particular' do
            let(:original_url) { 'http://r4d.dfid.gov.uk/erk' }
            example { expect(attachment.to_json[:content_type]).to eql('application/octet-stream') }
          end
        end
      end

      describe '#file and #file_future' do
        let(:tmp_path) { "/tmp/#{attachment.filename}" }

        let(:pdf_content) { 'This is PDF content, honest' }

        before do
          stub_request(:get, original_url).to_return(body: pdf_content)
        end

        after do
          File.delete(tmp_path) if File.exist?(tmp_path)
        end

        it 'has a Future for a #file_future' do
          expect(attachment.file_future).to be_a(Concurrent::Future)
        end

        it 'has the content of the PDF in #file as a File' do
          expect(attachment.file).to be_a(File)
          expect(attachment.file.read).to eql(pdf_content)
        end
      end
    end

    context 'given an extensionless URL that will probably 404 anyway' do
      let(:original_url) { 'http://r4d.dfid.gov.uk/pdf/outputs/FutureHealth_RPC/FHS_KMB#2_ResearchProg_Online.pdf' }

      it 'is assumed to be application/octet-stream to satisfy the schema' do
        expect(attachment.send(:content_type)).to eql('application/octet-stream')
      end
    end

    context 'given any FTP URL' do
      let(:original_url) { 'ftp://r4d.dfid.gov.uk/some/file.pdf' }

      it 'is always assumed offsite (in reality, no r4d FTP)' do
        expect(attachment).not_to be_hosted_at_r4d
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

    describe '#title' do
      context 'a filename with an extension' do
        let(:original_url) { 'http://example.com/some/path/title_of_the_file.pdf' }
        it 'is the same as the filename' do
          expect(attachment.title).to eql(attachment.filename)
        end

        it 'can be set to something else' do
          attachment.title = 'something else'
          expect(attachment.title).to eql('something else')
        end
      end
    end

    describe '#content_id' do
      let(:uuid) { /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }

      let(:original_url) { 'http://r4d.dfid.gov.uk/pdfs/some.pdf' }

      it 'is a uuid' do
        expect(attachment.content_id).to match uuid
      end

      it 'is only minted once' do
        expect(attachment.content_id).to eql(attachment.content_id)
      end
    end
  end
end
