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
  end
end
