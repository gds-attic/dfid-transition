require 'cgi'

module DfidTransition
  module Transform
    module UnescapeHtml

      def self.run(string_input)
        CGI.unescape_html(CGI.unescape_html(CGI.unescape_html(string_input)))
      end
    end
  end
end
