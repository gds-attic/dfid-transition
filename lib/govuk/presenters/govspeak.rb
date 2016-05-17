require 'govspeak'

module Govuk
  module Presenters
    module Govspeak
      class << self
        def present(govspeak)
          [
            { content_type: "text/govspeak", content: govspeak },
            {
              content_type: "text/html",
              content:      ::Govspeak::Document.new(govspeak).to_html
            }
          ]
        end
      end
    end
  end
end
