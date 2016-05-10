require 'spec_helper'
require 'dfid-transition/transform/html'

module DfidTransition::Transform
  describe Html do
    subject(:unescaped_html) do
      DfidTransition::Transform::Html.unescape_three_times(string_input)
    end

    context 'when given single html escaped HTML' do
      let(:string_input) { '&lt;p&gt;hello&lt;/p&gt;' }

      it "returns an unescaped string" do
        expect(unescaped_html).to eql('<p>hello</p>')
      end
    end

    context 'it has double-escaped HTML' do
      let(:double_escaped_html_examples) do
        {
          '&amp;#8216;Successful&amp;#8217; Development Models' =>
            '‘Successful’ Development Models',
          '&amp;lt;br/&amp;gt;&amp;lt;br/&amp;gt; This policy brief explores' =>
            '<br/><br/> This policy brief explores',
          'domestic violence.&amp;lt;/p&amp;gt;' =>
            'domestic violence.</p>',
          'various countries.&amp;lt;/p&amp;gt; &amp;lt;p&amp;gt;Given that both Mexico' =>
            'various countries.</p> <p>Given that both Mexico'
        }
      end

      it 'returns an unescaped string' do
        double_escaped_html_examples.each_pair do |escaped_string, desired_string|
          expect(
            DfidTransition::Transform::Html.unescape_three_times(escaped_string)
          ).to eql(desired_string)
        end
      end
    end

    context 'is has triple-escaped HTML' do
      let(:tripled_escaped_html_examples) do
        {
          'spread of India&amp;amp;#8217;s HIV epidemic' =>
            'spread of India’s HIV epidemic',
          'IPs&amp;amp;#8217; perceptions' =>
            'IPs’ perceptions',
        }
      end

      it 'returns an unescaped string' do
        tripled_escaped_html_examples.each_pair do |escaped_string, desired_string|
          expect(
            DfidTransition::Transform::Html.unescape_three_times(escaped_string)
          ).to eql(desired_string)
        end
      end
    end
  end

end
