require 'dfid-transition/patch/base'
require 'rest-client'

module DfidTransition
  module Patch
    class Regions < Base
      JSON_ENDPOINT = "http://linked-development.org/sparql.json"

      QUERY = <<-SPARQL
        prefix geo:<http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>

        SELECT DISTINCT ?codeUN ?nameShort
        WHERE {
          ?region a geo:geographical_region ;
                  geo:codeUN ?codeUN ;
                  geo:nameShort ?nameShort .

          FILTER(LANG(?nameShort) = "en")
        }
      SPARQL

      def mutate_schema
        results = RestClient.get JSON_ENDPOINT, params: { query: QUERY }

        region_facet['allowed_values'] = transform_to_label_value(results)
      end


      private

      def region_facet
        facet('region')
      end

      def transform_to_label_value(results)
        results_hash = JSON.parse results
        source_array = results_hash.dig "results", "bindings"

        source_array.inject([]) do |dest_array, result|
          name = result.dig('nameShort', 'value')
          dest_array << {
            label: name,
            value: name.downcase.gsub(' ', '-')
          }
          dest_array
        end
      end
    end
  end
end
