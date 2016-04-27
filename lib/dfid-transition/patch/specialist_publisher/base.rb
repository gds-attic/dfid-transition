require 'dfid-transition/patch/patcher'
require 'json'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Base < Patcher
        def facet(name)
          schema_hash['facets'].find { |f| f['key'] == name } ||
            raise(KeyError.new("No #{name} facet found"))
        end

        def mutate_schema
          raise NotImplementedError
        end

      private

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
end
