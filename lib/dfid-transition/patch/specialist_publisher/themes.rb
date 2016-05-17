require 'dfid-transition/patch/specialist_publisher/base'
require 'sparql'
require 'rdf/rdfxml'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Themes < Base
        QUERY = <<-SPARQL.freeze
          PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>

          SELECT DISTINCT ?theme ?prefLabel
          WHERE {
            ?theme skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/Themes> ;
                   skos:prefLabel ?prefLabel .
          }
          ORDER BY ?prefLabel
        SPARQL

        def mutate_schema
          r4d_solutions = sparql_client.query(QUERY)

          theme_facet['allowed_values'] = transform_to_label_value(
            r4d_solutions
          )
        end

      private

        def sparql_client
          @sparql_client ||= SPARQL::Client.new(repository)
        end

        def repository
          @repository ||= RDF::Repository.load('http://r4d.dfid.gov.uk/RDF/SKOS/Themes.rdf')
        end

        def theme_facet
          facet('theme')
        end

        def transform_to_label_value(r4d_solutions)
          r4d_solutions.map do |solution|
            theme_slug = solution['theme'].to_s.sub(%r{http://.*#}, '')

            {
              value: theme_slug,
              label: solution['prefLabel'].to_s
            }
          end
        end
      end
    end
  end
end
