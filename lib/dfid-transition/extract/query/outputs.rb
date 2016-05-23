require 'sparql/client'

module DfidTransition
  module Extract
    module Query
      ENDPOINT = 'http://linked-development.org/sparql'.freeze

      class Outputs
        QUERY = <<-SPARQL.freeze
          PREFIX dcterms: <http://purl.org/dc/terms/>
          PREFIX ont:     <http://purl.org/ontology/bibo/>
          PREFIX geo:     <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>
          PREFIX foaf:    <http://xmlns.com/foaf/0.1/>
          PREFIX prop:    <http://dbpedia.org/property/>

          SELECT DISTINCT ?output ?date ?abstract
                          ?projectTitle ?projectAbstract ?projectStart ?projectEnd ?programme
                          (GROUP_CONCAT(DISTINCT(?creator); separator = '|') AS ?creators)
                          (GROUP_CONCAT(DISTINCT(?titleSource)) AS ?title)
                          (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
          WHERE {
            ?output a ont:Article ;
                    dcterms:title ?titleSource ;
                    dcterms:abstract ?abstract ;
                    dcterms:date ?date ;
                    dcterms:isPartOf ?project .
            ?project dcterms:title ?projectTitle ;
                     dcterms:abstract ?projectAbstract ;
                     prop:start ?projectStart ;
                     prop:end ?projectEnd ;
                     prop:programme ?programme;

            OPTIONAL { ?output dcterms:coverage/geo:codeISO2 ?codeISO2 }
            OPTIONAL { ?output dcterms:creator/foaf:name     ?creator }

          } GROUP BY ?output ?date ?abstract
                     ?projectTitle ?projectAbstract ?projectStart ?projectEnd ?programme
          ORDER BY DESC(?date)
          LIMIT 20
        SPARQL

        def endpoint
          ENDPOINT
        end

        def solutions
          client.query(QUERY, content_type: SPARQL::Client::RESULT_JSON)
        end

      private

        def client
          @client ||= SPARQL::Client.new(endpoint, method: :get)
        end
      end
    end
  end
end
