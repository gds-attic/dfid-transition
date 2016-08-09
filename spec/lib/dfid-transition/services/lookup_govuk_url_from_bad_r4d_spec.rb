require 'spec_helper'
require 'dfid-transition/services/lookup_govuk_url_from_badr4d'

module DfidTransition::Services
  describe LookupGovukUrlFromBadr4d do
    describe '.[]' do
      subject { LookupGovukUrlFromBadr4d[bad_r4d_url] }
      let(:govuk_url) do
        'https://gov.uk/dfid-research-outputs/'\
        'moving-beyond-research-to-influence-policy-workshop-university-of-southampton-23-24-january-2001'
      end

      context 'no slash or default' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'a slash' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132/' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'two slashes' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132//' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'three slashes' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132///' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'Default.aspx' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132/Default.aspx' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'default.aspx' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/output/65132/default.aspx' }
        it { is_expected.to eql(govuk_url) }
      end

      context 'a project URL' do
        let(:bad_r4d_url) { 'http://linked-development.org/r4d/project/1479' }
        it { is_expected.to be_nil }
      end
    end
  end
end
