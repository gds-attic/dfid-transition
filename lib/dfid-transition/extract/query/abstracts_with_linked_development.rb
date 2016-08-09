require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class AbstractsWithLinkedDevelopment < Base
        def query
          <<-SPARQL
            PREFIX bibo: <http://purl.org/ontology/bibo/>
            PREFIX terms: <http://purl.org/dc/terms/>

            SELECT ?output ?title ?abstract
            WHERE {
              ?output
                a              bibo:Article ;
                terms:title    ?title ;
                terms:abstract ?abstract .

                FILTER(regex(str(?abstract), 'linked-development\.org'))
            }
          SPARQL
        end
      end
    end
  end
end
