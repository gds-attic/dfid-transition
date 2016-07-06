require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class Outputs < Base
        QUERY = <<-SPARQL.freeze
          PREFIX dcterms: <http://purl.org/dc/terms/>
          PREFIX geo:     <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>
          PREFIX foaf:    <http://xmlns.com/foaf/0.1/>
          PREFIX bibo:    <http://purl.org/ontology/bibo/>
          PREFIX status:  <http://purl.org/bibo/status/>

          SELECT DISTINCT ?output ?date ?abstract ?title ?citation
            (EXISTS { ?output bibo:DocumentStatus status:peerReviewed } AS ?peerReviewed)
            (GROUP_CONCAT(DISTINCT(?creator); separator = '|') AS ?creators)
            (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
            (GROUP_CONCAT(DISTINCT(?uri)) AS ?uris)
          WHERE {
            ?output a bibo:Article ;
                    dcterms:title ?title ;
                    dcterms:abstract ?abstract ;
                    dcterms:bibliographicCitation ?citation ;
                    dcterms:date ?date ;
                    bibo:uri ?uri .

            OPTIONAL { ?output dcterms:coverage/geo:codeISO2 ?codeISO2 }
            OPTIONAL { ?output dcterms:creator/foaf:name     ?creator }

          } GROUP BY ?output ?date ?abstract ?title ?citation
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
