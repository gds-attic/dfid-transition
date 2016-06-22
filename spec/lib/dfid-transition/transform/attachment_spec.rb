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
  end
end
