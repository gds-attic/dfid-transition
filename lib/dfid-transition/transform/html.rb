require 'cgi'
require 'kramdown'
require 'nokogiri'
require 'dfid-transition/services/lookup_govuk_url_from_badr4d'

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
        corrected_html =
          correct_malformed_lists(
            replace_linked_development_hrefs(
              expand_h3s(fragment)
            )
          ).to_s

        kramdown_tree, _warnings = Kramdown::Parser::Html.parse(corrected_html)
        Kramdown::Converter::Kramdown.convert(kramdown_tree).first
      end

      BADLY_ENCODED_P = '&amp;amp;#55349;&amp;amp;#56387;'.freeze
      BADLY_ENCODED_LIST_ITEM_VARIANT_1 = '&amp;amp;#56256;&amp;amp;#56457;'.freeze
      BADLY_ENCODED_LIST_ITEM_VARIANT_2 = '&amp;amp;#56256;&amp;amp;#56451;'.freeze

      def self.fix_encoding_errors(html)
        html.sub(BADLY_ENCODED_P, 'p') \
            .gsub(BADLY_ENCODED_LIST_ITEM_VARIANT_1, '* ')
            .gsub(BADLY_ENCODED_LIST_ITEM_VARIANT_2, '* ')
      end

      HEADER_ENDS_WITH_COLON = /[a-z]{2,}:\s*$/

      def self.correct_malformed_lists(frag)
        frag = Nokogiri::HTML.fragment(frag) unless frag.is_a?(Nokogiri::HTML::DocumentFragment)
        frag.css('ol, ul').each do |list|
          list.add_previous_sibling('<br /><br />')
        end
        frag
      end

      def self.expand_h3s(frag)
        frag = Nokogiri::HTML.fragment(frag) unless frag.is_a?(Nokogiri::HTML::DocumentFragment)

        header_nodes = frag.css('b,strong').select { |f| f.content =~ HEADER_ENDS_WITH_COLON }

        header_nodes.each do |node|
          node.name = 'h3'
          node.content = node.content.sub(':', '')
          node.add_previous_sibling('<br/><br/>')
          node.next_sibling.content = node.next_sibling.content.sub(/^\s*/, '')
        end
        frag
      end

      def self.replace_linked_development_hrefs(frag)
        frag = Nokogiri::HTML.fragment(frag) unless frag.is_a?(Nokogiri::HTML::DocumentFragment)

        linked_development_anchors = frag.css('a').select { |a| a['href'] =~ /linked-development/ }
        linked_development_anchors.each do |a|
          href = a['href']
          case href
          when /output/
            new_govuk_url = DfidTransition::Services::LookupGovukUrlFromBadr4d[href]
            a['href'] = new_govuk_url if new_govuk_url
          when /project/
            a.replace(a.text)
          end
        end

        frag
      end
    end
  end
end
