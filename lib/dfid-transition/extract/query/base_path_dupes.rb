require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class BasePathDupes < Base
        QUERY = <<-SPARQL.freeze
          PREFIX dcterms: <http://purl.org/dc/terms/>
          PREFIX ont:     <http://purl.org/ontology/bibo/>

          SELECT DISTINCT ?output
                          (GROUP_CONCAT(DISTINCT(?titleSource)) AS ?title)
          WHERE {
            ?output a ont:Article ;
                    dcterms:title ?titleSource .
          } GROUP BY ?output
          ORDER BY DESC(?date)
        SPARQL

        def query
          QUERY
        end
      end
    end
  end
end
