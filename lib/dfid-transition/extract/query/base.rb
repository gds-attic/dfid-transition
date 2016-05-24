require 'sparql/client'

module DfidTransition
  module Extract
    module Query
      DEFAULT_ENDPOINT = 'http://linked-development.org/sparql'.freeze

      def self.endpoint
        @endpoint ||= (ENV['SPARQL_ENDPOINT'] || DEFAULT_ENDPOINT)
      end

      def self.endpoint=(new_endpoint)
        @endpoint = new_endpoint
      end

      class Base
        def query
          raise NotImplementedError
        end

        def endpoint
          Query.endpoint
        end

        def solutions
          client.query(query, content_type: SPARQL::Client::RESULT_JSON)
        end

      private

        def client
          @client ||= SPARQL::Client.new(endpoint, method: :get)
        end
      end
    end
  end
end
