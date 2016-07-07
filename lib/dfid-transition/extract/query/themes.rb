require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class Themes < Base
        QUERY = <<-SPARQL.freeze
          PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

          SELECT DISTINCT ?theme ?prefLabel
          WHERE {
            ?theme skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/Themes> ;
              skos:prefLabel ?prefLabel ;
              skos:narrower ?narrower .
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
