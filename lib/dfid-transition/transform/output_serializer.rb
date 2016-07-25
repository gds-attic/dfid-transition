require 'sparql/client'
require 'rdf/json/extensions'

module DfidTransition
  module Transform
    class OutputSerializer
      attr_accessor :solution

      def initialize(solution)
        self.solution = solution
      end

      def serialize
        hash = {
          'head' => {
            'vars' => field_names(solution)
          },
          'results' => {
            'bindings' => [
              solution.bindings.each_with_object({}) do |binding, binding_hash|
                binding.tap do |name, value|
                  binding_hash[name] = value.to_rdf_json
                end
              end
            ]
          }
        }

        JSON.generate(hash)
      end

      def self.deserialize(json)
        SPARQL::Client.parse_json_bindings(json)
      end

      def self.serialize(solution)
        self.new(solution).serialize
      end

      def field_names(solution)
        solution.bindings.map { |binding| binding.first.to_s }
      end
    end
  end
end
