require 'dfid-transition/patch/patcher'

module DfidTransition
  module Patch
    module Rummager
      class Base < Patcher
        def mutate_schema
          raise NotImplementedError
        end

      private

        def relative_path
          File.expand_path(
            File.join(
              Dir.pwd,
              '..',
              'rummager',
              'config/schema/document_types/dfid_research_output.json'
            )
          )
        end
      end
    end
  end
end
