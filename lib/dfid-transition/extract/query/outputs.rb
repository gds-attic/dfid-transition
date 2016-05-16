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

          SELECT DISTINCT ?output ?date ?abstract
                          (GROUP_CONCAT(DISTINCT(?titleSource)) AS ?title)
                          (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
                          (GROUP_CONCAT(DISTINCT(?nameShort); separator = '|') AS ?countryNames)
          WHERE {
            ?output a ont:Article ;
                    dcterms:title ?titleSource ;
                    dcterms:abstract ?abstract ;
                    dcterms:date ?date ;
                    dcterms:coverage ?country .
            ?country a geo:self_governing ;
                     geo:codeISO2 ?codeISO2 ;
                     geo:nameShort ?nameShort .
            FILTER (LANG(?nameShort) = 'en')
          } GROUP BY ?output ?date ?abstract
          ORDER BY DESC(?date)
          LIMIT 10
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
