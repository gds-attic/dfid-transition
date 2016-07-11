require 'dfid-transition/transform/document_types'
require 'dfid-transition/patch/govuk_content_schemas/base'

module DfidTransition
  module Patch
    module GovukContentSchemas
      class DocumentTypes < Base
        include DfidTransition::Transform::DocumentTypes

        def mutate_schema
          dfid_properties['dfid_document_type'] = {
            'type' => 'string',
            'items' => {
              'type' => 'string',
              'enum' => document_type_identifiers
            }
          }
        end

      private

        def document_type_identifiers
          document_types_query.solutions.map do |solution|
            parameterize(solution[:type].to_s)
          end
        end
      end
    end
  end
end
