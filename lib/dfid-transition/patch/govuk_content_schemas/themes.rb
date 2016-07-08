require 'dfid-transition/transform/themes'
require 'dfid-transition/patch/govuk_content_schemas/base'

module DfidTransition
  module Patch
    module GovukContentSchemas
      class Themes < Base
        include DfidTransition::Transform::Themes

        def mutate_schema
          dfid_properties['dfid_theme'] = {
            'type' => 'array',
            'items' => {
              'type' => 'string',
              'enum' => theme_identifiers
            }
          }
        end

      private

        def theme_identifiers
          themes_query.solutions.map do |solution|
            parameterize(solution[:theme].to_s)
          end
        end
      end
    end
  end
end
