require 'dfid-transition/extract/query/document_types'

module DfidTransition
  module Transform
    ##
    # For patchers that need to query document types and transform those
    # values
    #
    module DocumentTypes
      def document_types_query
        @document_types_query ||= DfidTransition::Extract::Query::DocumentTypes.new
      end

      def transform_to_label_value(r4d_solutions)
        r4d_solutions.map do |solution|
          type_slug = parameterize(solution['type'].to_s)

          {
            value: type_slug,
            label: solution['prefLabel'].to_s
          }
        end
      end

      def parameterize(type_url)
        type_url.
          sub(%r{http://.*#}, ''). # Strip http://....#
          gsub('/', '_').          # underscore slashes
          gsub('%20', '_').        # underscore escaped spaces
          downcase
      end
    end
  end
end
