require 'dfid-transition/extract/query/themes'
require 'dfid-transition/patch/specialist_publisher/base'
require 'sparql'
require 'rdf/rdfxml'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Themes < Base
        def mutate_schema
          theme_facet['allowed_values'] =
            transform_to_label_value(themes_query.solutions)
        end

      private

        def themes_query
          @themes_query ||= DfidTransition::Extract::Query::Themes.new
        end

        def theme_facet
          facet('theme')
        end

        def transform_to_label_value(r4d_solutions)
          r4d_solutions.map do |solution|
            theme_slug = parameterize(solution['theme'].to_s)

            {
              value: theme_slug,
              label: solution['prefLabel'].to_s
            }
          end
        end

        def parameterize(theme_url)
          theme_url.
            sub(%r{http://.*#}, '').  # Strip http://....#
            gsub('%20', '_').         # underscore escaped spaces
            downcase
        end
      end
    end
  end
end
