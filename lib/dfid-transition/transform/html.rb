require 'cgi'
require 'kramdown'
require 'nokogiri'

module DfidTransition
  module Transform
    module Html
      def self.unescape_three_times(string_input)
        CGI.unescape_html(
          CGI.unescape_html(
            CGI.unescape_html(string_input)
          )
        )
      end

      def self.to_markdown(html)
        fragment = Nokogiri::HTML.fragment(html)
        corrected_html = expand_h3s(fragment)

        kramdown_tree, _warnings = Kramdown::Parser::Html.parse(corrected_html)
        Kramdown::Converter::Kramdown.convert(kramdown_tree).first
      end

      BADLY_ENCODED_P = '&amp;amp;#55349;&amp;amp;#56387;'
      BADLY_ENCODED_LIST_ITEM_VARIANT_1 = '&amp;amp;#56256;&amp;amp;#56457;'
      BADLY_ENCODED_LIST_ITEM_VARIANT_2 = '&amp;amp;#56256;&amp;amp;#56451;'

      def self.fix_encoding_errors(html)
        html.sub(BADLY_ENCODED_P, 'p') \
            .gsub(BADLY_ENCODED_LIST_ITEM_VARIANT_1, '* ')
            .gsub(BADLY_ENCODED_LIST_ITEM_VARIANT_2, '* ')
      end

      HEADER_ENDS_WITH_COLON = /[a-z]{2,}:\s*$/

      def self.expand_h3s(frag)
        frag = Nokogiri::HTML.fragment(frag) unless frag.is_a?(Nokogiri::HTML::DocumentFragment)

        header_nodes = frag.css('b,strong').select { |f| f.content =~ HEADER_ENDS_WITH_COLON }

        header_nodes.each do |node|
          node.name = 'h3'
          node.content = node.content.sub(':', '')
          node.add_previous_sibling('<br/><br/>')
          node.next_sibling.content = node.next_sibling.content.sub(/^\s*/, '')
        end
        frag.to_s
      end
    end
  end
end
