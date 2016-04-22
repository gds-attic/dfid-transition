module DfidTransition
  module Patch
    class Base
      attr_reader :location

      def initialize(location = nil)
        @location = location || relative_path
      end

      def facet(name)
        schema_hash['facets'].find { |f| f['key'] == name } ||
          raise(KeyError.new("No #{name} facet found"))
      end

      def mutate_schema
        raise NotImplementedError
      end

      def run
        File.exist?(location) || raise(Errno::ENOENT.new(location))

        mutate_schema

        File.open(location, 'w+') do |target|
          target.write(JSON.pretty_generate(schema_hash))
        end
      end

    private

      def schema_hash
        @schema_hash ||= JSON.parse(File.read(location))
      end

      def relative_path
        File.expand_path(
          File.join(
            Dir.pwd,
            '..',
            'specialist-publisher-rebuild',
            'lib/documents/schemas/dfid_research_outputs.json'
          )
        )
      end
    end
  end
end
