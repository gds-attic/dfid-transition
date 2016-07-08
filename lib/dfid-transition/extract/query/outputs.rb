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
          PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>

          SELECT DISTINCT ?output ?date ?type ?abstract ?title ?citation
            (EXISTS { ?output bibo:DocumentStatus status:peerReviewed } AS ?peerReviewed)
            (GROUP_CONCAT(DISTINCT(?creator); separator = '|') AS ?creators)
            (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
            (GROUP_CONCAT(DISTINCT(?uri)) AS ?uris)
            (GROUP_CONCAT(DISTINCT(?theme)) AS ?themes)
          WHERE {
            ?output a bibo:Article ;
                    dcterms:type ?type ;
                    dcterms:title ?title ;
                    dcterms:abstract ?abstract ;
                    dcterms:bibliographicCitation ?citation ;
                    dcterms:date ?date ;
                    dcterms:subject ?theme ;
                    bibo:uri ?uri .

            FILTER ( ?type != 'text' )

            {
              ?theme skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/Themes>
              FILTER EXISTS { ?theme skos:narrower ?narrowerTheme }
            }

            OPTIONAL { ?output dcterms:coverage/geo:codeISO2 ?codeISO2 }
            OPTIONAL { ?output dcterms:creator/foaf:name     ?creator }

          } GROUP BY ?output ?date ?type ?abstract ?title ?citation
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
