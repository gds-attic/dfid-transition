require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class DocumentTypes < Base
        QUERY = <<-SPARQL.freeze
          PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

          SELECT DISTINCT ?type ?prefLabel
          WHERE {
            ?type skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/DocumentTypes> ;
              skos:prefLabel ?prefLabel .
          }
          ORDER BY ?prefLabel
        SPARQL

        def query
          QUERY
        end
      end
    end
  end
end
