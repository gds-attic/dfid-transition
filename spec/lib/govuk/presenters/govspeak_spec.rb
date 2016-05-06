require 'spec_helper'
require 'govuk/presenters/govspeak'

describe Govuk::Presenters::Govspeak do
  subject(:rendered) { Govuk::Presenters::Govspeak.present(govspeak) }

  context 'valid govspeak is given' do
    let(:govspeak) { "## A header\nsome text" }

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
    end

    describe 'the second section' do
      subject(:section) { rendered.last }
      it 'is of type text/html' do
        expect(section[:content_type]).to eql('text/html')
      end
      it 'has the rendered text' do
        expect(section[:content]).to include('<p>some text')
      end
    end
  end
end
