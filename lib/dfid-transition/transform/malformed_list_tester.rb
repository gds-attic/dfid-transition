require 'dfid-transition/transform/html'

module DfidTransition
  module Transform
    class MalformedListTester
      Html = DfidTransition::Transform::Html

      attr_reader :solution

      def initialize(solution)
        @solution = solution
      end

      def has_malformed_ul?
        abstract.match(/\* /) && !abstract.match(/\n\n\* /)
      end

      def has_malformed_ol?
        abstract.match(/1\. /) && abstract.match(/2\. /) && !abstract.match(/\n\n1\. /)
      end

      def has_malformed_list?
        has_malformed_ol? || has_malformed_ul?
      end

      def abstract
        @abstract ||= self.to_markdown(
          Html.unescape_three_times(
            Html.fix_encoding_errors(
              solution[:abstract].to_s
            )
          )
        )
      end

      def to_markdown(html)
        fragment = Nokogiri::HTML.fragment(html)
        corrected_html = fragment.to_s

        kramdown_tree, _warnings = Kramdown::Parser::Html.parse(corrected_html)
        Kramdown::Converter::Kramdown.convert(kramdown_tree).first
      end
    end
  end
end
