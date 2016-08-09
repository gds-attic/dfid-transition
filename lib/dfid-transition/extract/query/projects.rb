require 'dfid-transition/extract/query/base'

module DfidTransition
  module Extract
    module Query
      class Projects < Base
        DEFAULT_LIMIT = 20

        def limit
          (options[:limit] || DEFAULT_LIMIT).tap do |check_is_integer|
            Integer(check_is_integer)
          end
        end

        def query
          <<-SPARQL.freeze
            PREFIX terms: <http://purl.org/dc/terms/>
            PREFIX bibo:    <http://purl.org/ontology/bibo/>

            SELECT DISTINCT ?project
            WHERE {
              ?output a bibo:Article ;
                      terms:isPartOf ?project .
            }
            LIMIT #{limit}
          SPARQL
        end
      end
    end
  end
end
