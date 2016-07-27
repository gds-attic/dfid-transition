require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class DuplicateTitles < Base
        QUERY = <<-SPARQL.freeze
          PREFIX dcterms: <http://purl.org/dc/terms/>
          PREFIX ont:     <http://purl.org/ontology/bibo/>

          SELECT ?title (COUNT(DISTINCT ?output) AS ?outputCount)
          WHERE {
            ?output a ont:Article ;
                    dcterms:title ?title .
          } GROUP BY ?title
          HAVING(COUNT(DISTINCT ?output) > 1)
          ORDER BY DESC(?outputCount)
        SPARQL

        def query
          QUERY
        end
      end
    end
  end
end
