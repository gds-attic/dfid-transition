require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class OutputsByUri < Base
        def query
          <<-SPARQL
            PREFIX dcterms: <http://purl.org/dc/terms/>
            PREFIX bibo:    <http://purl.org/ontology/bibo/>

            SELECT ?output ?title
            WHERE {
              ?output a bibo:Article ;
                      dcterms:title ?title .

              FILTER(?output IN
                (
                  #{output_uris}
                )
              )
            }
          SPARQL
        end

        def output_uris
          options[:output_uris].map { |uri| "\t\t\t\t\t<#{uri}>" }.join(",\n")
        end
      end
    end
  end
end
