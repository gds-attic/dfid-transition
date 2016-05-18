require 'cgi'
require 'kramdown'

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
        kramdown_tree, _warnings = Kramdown::Parser::Html.parse(html)
        Kramdown::Converter::Kramdown.convert(kramdown_tree).first
      end
    end
  end
end
