require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class Outputs < Base
        QUERY = <<-SPARQL.freeze
          PREFIX dcterms: <http://purl.org/dc/terms/>
          PREFIX ont:     <http://purl.org/ontology/bibo/>
          PREFIX geo:     <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>
          PREFIX foaf:    <http://xmlns.com/foaf/0.1/>

          SELECT DISTINCT ?output ?date ?abstract
                          (GROUP_CONCAT(DISTINCT(?creator); separator = '|') AS ?creators)
                          (GROUP_CONCAT(DISTINCT(?titleSource)) AS ?title)
                          (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
          WHERE {
            ?output a ont:Article ;
                    dcterms:title ?titleSource ;
                    dcterms:abstract ?abstract ;
                    dcterms:date ?date .

            OPTIONAL { ?output dcterms:coverage/geo:codeISO2 ?codeISO2 }
            OPTIONAL { ?output dcterms:creator/foaf:name     ?creator }

          } GROUP BY ?output ?date ?abstract
          ORDER BY DESC(?date)
          LIMIT 20
        SPARQL

        def query
          QUERY
        end
      end
    end
  end
end
