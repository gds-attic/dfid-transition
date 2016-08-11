require 'spec_helper'
require 'dfid-transition/transform/html'
require 'active_support/core_ext/string/strip'

module DfidTransition::Transform
  describe Html do
    describe '.unescaped_html' do
      subject(:unescaped_html) do
        Html.unescape_three_times(string_input)
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

    describe '.fix_encoding_errors' do
      subject(:fixed_html) { Html.fix_encoding_errors(string_input) }

      context 'output 190756 is trying to say p < 0.001' do
        let(:string_input) do
          "Combined analysis of variance showed significant differences "\
          "( &amp;amp;#55349;&amp;amp;#56387; &amp;amp;lt; 0.001 ) among genotypes (G), ..."
        end

        it 'resolves to a p' do
          expect(fixed_html).to include('( p &amp;amp;lt; 0.001 )')
        end
      end

      context 'output 180523 (and the others) look like a list' do
        let(:string_input) do
          "The presentation outline is: &amp;lt;br/&amp;gt;&amp;lt;br/&amp;gt;Definitional clarity \u2013what do we mean by human mobility?&amp;lt;br/&amp;gt; &amp;amp;#56256;&amp;amp;#56457;Vulnerability as the main driver to human mobility&amp;lt;br/&amp;gt; &amp;amp;#56256;&amp;amp;#56457;The African continent and climate change&amp;lt;br/&amp;gt; &amp;amp;#56256;&amp;amp;#56457;Links between climate change, human mobility and environmental degradation&amp;lt;br/&amp;gt; &amp;amp;#56256;&amp;amp;#56457;Building adaptive capacity and resilience \u2013CCAA\u2019s action research strategy, objectives, &amp;amp; responses&amp;lt;br/&amp;gt; &amp;amp;#56256;&amp;amp;#56457;Concluding Remarks. "
        end

        it 'resolves to a list' do
          expect(fixed_html).not_to include('&amp;amp;#56256;&amp;amp;#56457')
          expect(fixed_html).to include('* ')
        end
      end

      context 'output 176870 looks like a list' do
        let(:string_input) do
          "as follows:&amp;lt;br/&amp;gt;&amp;lt;br/&amp;gt;&amp;amp;#56256;&amp;amp;#56451; Surface seals&amp;lt;br/&amp;gt;&amp;amp;#56256;&amp;amp;#56451; Stabilised bases and sub-bases&amp;lt;br/&amp;gt;"
        end

        it 'resolves to a list' do
          expect(fixed_html).not_to include('&amp;amp;#56256;&amp;amp;#56451;')
          expect(fixed_html).to include('* ')
        end
      end
    end

    describe '.to_markdown' do
      subject(:markdown) do
        Html.to_markdown(string_input)
      end

      context 'Everything is peachy' do
        let(:string_input) do
          <<-HTML.strip_heredoc
            <p>This is para 1</p>
            <p>This is para 2</p>
            <ul>
              <li>A list item</li>
            </ul>
          HTML
        end
        it 'has the paras' do
          expect(markdown).to include("This is para 1\n\nThis is para 2")
        end
        it 'has the list' do
          expect(markdown).to match(/\n\* A list item/)
        end
      end

      context 'there are lists in paragraphs' do
        let(:string_input) do
          <<-HTML.strip_heredoc
            <p>This is a para. Lists should not appear here,
               because an HTML parser will close the 'p' tag
               to cope, leaving a trailing 'p'.
               Oh dear!

               <ul>
                 <li>BOING</li>
                 <li>BOING</li>
               </ul>
            </p>
          HTML
        end

        it 'expands the list and closes the para beforehand. A newline separates' do
          expect(markdown).to include('This is a para. Lists should not appear')
          expect(markdown).to include("\n* BOING\n* BOING")
        end
      end
    end

    describe '.expand_h3s' do
      subject(:result_as_str) do
        Html.expand_h3s(abstract).to_s
      end

      context 'Query, Summary, Key findings are b or strong' do
        let(:abstract) do
          <<-TEXT
            This is a piece of abstract.

            <b>Query:</b> Something that's a query

            <strong>Summary:</strong> Something that's a summary.

            <b>Key Findings:</b> These are key findings
          TEXT
        end

        it 'expands query and summary to h3' do
          expect(result_as_str).to include('<h3>Query</h3>')
          expect(result_as_str).to include('<h3>Summary</h3>')
        end

        it 'expands key findings to h3' do
          expect(result_as_str).to include('<h3>Key Findings</h3>')
        end
      end
    end
  end
end
