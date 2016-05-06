require 'securerandom'
require 'cgi'
require 'govuk/presenters/govspeak'

module DfidTransition
  LINKED_DEVELOPMENT_OUTPUT_URI =
    %r{http://linked-development.org/r4d/output/(?<id>[0-9]+?)/}
  ORGANISATION_CONTENT_ID       = "b994552-7644-404d-a770-a2fe659c661f"

  module Transform
    class Document
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
        stripped_title = solution[:title].to_s.strip
        corrected_ampersands = stripped_title.gsub('&amp;', '&')
        CGI.unescape_html(corrected_ampersands)
      end

      def summary
        solution[:summary].to_s.strip
      end

      def base_path
        "/dfid-research-outputs/#{original_id}"
      end

      def metadata
        { document_type: "dfid_research_output" }
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

      def details
        {
          body: Govuk::Presenters::Govspeak.present(summary),
          metadata: metadata
          # change_history: change_history
        }

        # Attachments would be handled here
        #.tap do |details_hash|
        #  details_hash[:attachments] = attachments if document.attachments
        #end
      end

      def body
        details[:body]
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
