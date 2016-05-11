require 'spec_helper'
require 'dfid-transition/transform/html'

module DfidTransition::Transform
  describe Html do
    subject(:unescaped_html) do
      DfidTransition::Transform::Html.unescape_three_times(string_input)
    end

    context 'HTML is single-escaped' do
      let(:string_input) { '&lt;p&gt;hello&lt;/p&gt;' }
      it { is_expected.to eql('<p>hello</p>') }
    end

    context 'HTML is double-escaped' do
      context 'There are special character encodes' do
        let(:string_input) { '&amp;#8216;Successful&amp;#8217; Development Models' }
        it { is_expected.to eql('‘Successful’ Development Models') }
      end
      context 'There are double-escaped tags' do
        let(:string_input) { '&amp;lt;br/&amp;gt;&amp;lt;br/&amp;gt; This policy brief explores' }
        it { is_expected.to eql('<br/><br/> This policy brief explores') }
      end
      context 'there are unmatched tags' do
        let(:string_input) { 'domestic violence.&amp;lt;/p&amp;gt;' }
        it 'does not care' do
          expect(unescaped_html).to eql('domestic violence.</p>')
        end
      end
    end

    context 'HTML is triple-escaped' do
      let(:string_input) { 'spread of India&amp;amp;#8217;s HIV epidemic' }
      it { is_expected.to eql('spread of India’s HIV epidemic') }
    end
  end

end
