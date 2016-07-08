require 'dfid-transition/extract/query/document_types'
require 'dfid-transition/patch/rummager/base'
require 'dfid-transition/transform/document_types'

module DfidTransition
  module Patch
    module Rummager
      class DocumentTypes < Base
        include DfidTransition::Transform::DocumentTypes

        def mutate_schema
          add_document_type_field
          add_document_type_expansions
        end

      private

        def add_document_type_field
          unless schema_hash.fetch('fields').include?('dfid_document_type')
            schema_hash.fetch('fields') << 'dfid_document_type'
          end
        end

        def add_document_type_expansions
          schema_hash['expanded_search_result_fields']['dfid_document_type'] =
            transform_to_label_value(document_types_query.solutions)
        end
      end
    end
  end
end
