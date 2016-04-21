require 'dfid-transition/patch/base'
require 'sparql'
require 'rdf/rdfxml'
require 'json'

module DfidTransition
  module Patch
    class Themes < Base
      QUERY = <<-SPARQL
        PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>

        SELECT DISTINCT ?theme ?prefLabel
        WHERE {
          ?theme skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/Themes> ;
                 skos:prefLabel ?prefLabel .
        }
      SPARQL

      def mutate_schema
        repository = RDF::Repository.load('http://r4d.dfid.gov.uk/RDF/SKOS/Themes.rdf')
        sparql = SPARQL::Client.new(repository)

        results = sparql.query(QUERY)

        theme_facet['allowed_values'] = transform_to_label_value(results)
      end

    private
      def theme_facet
        facet('theme')
      end

      def transform_to_label_value(results)
        results.map do |solution|
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
