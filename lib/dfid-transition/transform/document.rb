require 'securerandom'
require 'cgi'
require 'govuk/presenters/govspeak'
require 'dfid-transition/transform/html'
require 'active_support/core_ext/string/strip'

module DfidTransition
  LINKED_DEVELOPMENT_OUTPUT_URI =
    %r{http://linked-development.org/r4d/output/(?<id>[0-9]+?)/}
  ORGANISATION_CONTENT_ID       = "b994552-7644-404d-a770-a2fe659c661f".freeze

  module Transform
    class Document
      Html = DfidTransition::Transform::Html

      attr_reader :solution
      attr_accessor :content_id

      def initialize(solution)
        @solution = solution
        @content_id = SecureRandom.uuid
      end

      def original_id
        match = solution[:output].to_s.match(/\/(?<id>[0-9]+?)\//)
        match[:id]
      end

      def original_url
        output_url = solution[:output].to_s
        match = output_url.match LINKED_DEVELOPMENT_OUTPUT_URI
        if match
          "http://r4d.dfid.gov.uk/Output/#{match[:id]}/Default.aspx"
        else
          output_url
        end
      end

      def title
        title = solution[:title].to_s
        unescaped_title = Html.unescape_three_times(title)
        unescaped_title.strip
      end

      def summary
        "This is an example summary for output #{original_id}. The citation would ordinarily
         appear here but we need CABI to include that data in their triples."
      end

      def base_path
        "/dfid-research-outputs/#{original_id}"
      end

      def metadata
        {
          document_type: "dfid_research_output",
          country: countries
        }
      end

      def public_updated_at
        solution[:date].to_s
      end

      def countries
        solution[:countryCodes].to_s.split(' ')
      end

      def format_specific_metadata
        { country: countries }
      end

      def organisations
        [ORGANISATION_CONTENT_ID]
      end

      def change_history
        [{
          public_timestamp: public_updated_at,
          note:             'First published.'
        }]
      end

      def details
        {
          body: Govuk::Presenters::Govspeak.present(body),
          metadata: metadata,
          change_history: change_history
        }.tap do |details_hash|
          details_hash[:headers] = headers
          #  details_hash[:attachments] = attachments if document.attachments
        end
      end

      def abstract
        @abstract ||= Html.to_markdown(
          Html.unescape_three_times(solution[:abstract].to_s)
        )
      end

      def body
        "## Abstract"\
        "\n"\
        "#{abstract}"
      end

      def headers
        headers = Govspeak::Document.new(body).structured_headers
        remove_empty_headers(headers.map(&:to_h))
      end

      def remove_empty_headers(headers)
        headers.each do |header|
          header.delete_if { |k, v| k == :headers && v.empty? }
          remove_empty_headers(header[:headers]) if header.has_key?(:headers)
        end
      end

      def to_json
        {
          content_id:        content_id,
          base_path:         base_path,
          title:             title,
          description:       summary,
          document_type:     'dfid_research_output',
          schema_name:       "specialist_document",
          publishing_app:    "specialist-publisher",
          rendering_app:     "specialist-frontend",
          locale:            "en",
          phase:             'live',
          public_updated_at: public_updated_at,
          details:           details,
          routes:            [
                               {
                                 path: base_path,
                                 type: "exact",
                               }
                             ],
          redirects:         [],
          update_type:       'minor',
          organisations:     organisations
        }
      end
    end
  end
end
