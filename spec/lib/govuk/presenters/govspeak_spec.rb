require 'spec_helper'
require 'govuk/presenters/govspeak'
require 'dfid-transition/transform/attachment'

describe Govuk::Presenters::Govspeak do
  Attachment = DfidTransition::Transform::Attachment
  let(:attachments) { [] }

  subject(:rendered) { Govuk::Presenters::Govspeak.new(govspeak, attachments).present }

  context 'valid govspeak and attachments are given' do
    let(:govspeak) {
      "## A header\nsome text\n#{onsite_attachment.snippet}"
    }
    let(:offsite_attachment) do
      Attachment.new('http://example.com/a.pdf')
    end
    let(:onsite_attachment) do
      Attachment.new('http://r4d.dfid.gov.uk/pdfs/foobar.pdf').tap do |attachment|
        allow(attachment).to receive(:asset_response).and_return(double(file_url: 'http://asset.url'))
      end
    end
    let(:attachments) { [offsite_attachment, onsite_attachment] }

    it 'renders two sections' do
      expect(rendered.size).to eql(2)
    end

    describe 'the first section' do
      subject(:section) { rendered.first }
      it 'is of type content/govspeak' do
        expect(section[:content_type]).to eql('text/govspeak')
      end
      it 'has the raw text' do
        expect(section[:content]).to include('## A header')
      end
      it 'keeps the links as they are' do
        expect(section[:content]).to include('[InlineAttachment:foobar.pdf]')
      end
    end

    describe 'the second section' do
      subject(:section) { rendered.last }
      it 'is of type text/html' do
        expect(section[:content_type]).to eql('text/html')
      end
      it 'has the rendered text' do
        expect(section[:content]).to include('<p>some text')
      end
      it 'resolves InlineAttachments to external links' do
        expect(section[:content]).to include('<a rel="external" href="http://asset.url">foobar.pdf</a><')
      end
    end
  end
end
