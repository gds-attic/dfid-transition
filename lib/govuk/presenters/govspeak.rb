require 'govspeak'

module Govuk
  module Presenters
    class Govspeak
      attr_accessor :govspeak, :attachments

      def initialize(govspeak, attachments)
        self.govspeak = govspeak
        self.attachments = attachments
      end

      def present
        [
          { content_type: "text/govspeak", content: govspeak },
          {
            content_type: "text/html",
            content:      ::Govspeak::Document.new(resolve_inline_attachments).to_html
          }
        ]
      end

      def resolve_inline_attachments
        attachments.select(&:hosted_at_r4d?).inject(govspeak) do |body, attachment|
          body.gsub(attachment.snippet, attachment.link_to_asset)
        end
      end
    end
  end
end
