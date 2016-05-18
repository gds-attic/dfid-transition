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
        it {
          is_expected.to eql(<<-MARKDOWN.strip_heredoc
            This is para 1

            This is para 2

            * A list item

            MARKDOWN
          )
        }
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
  end
end
