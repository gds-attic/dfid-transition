require 'cgi'

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
    end
  end
end
