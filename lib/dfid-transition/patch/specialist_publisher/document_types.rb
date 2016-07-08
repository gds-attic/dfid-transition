require 'dfid-transition/transform/document_types'
require 'dfid-transition/patch/specialist_publisher/base'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class DocumentTypes < Base
        include DfidTransition::Transform::DocumentTypes

        def mutate_schema
          document_type_facet['allowed_values'] =
            transform_to_label_value(document_types_query.solutions)
        end

      private

        def document_type_facet
          facet('dfid_document_type')
        end
      end
    end
  end
end
