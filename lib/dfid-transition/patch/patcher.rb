require 'json'

module DfidTransition
  module Patch
    class Patcher
      attr_reader :location

      def initialize(location = nil)
        @location = location || relative_path
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
        raise NotImplementedError
      end
    end
  end
end
