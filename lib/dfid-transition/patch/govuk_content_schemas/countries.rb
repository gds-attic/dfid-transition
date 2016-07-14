require 'dfid-transition/patch/govuk_content_schemas/base'
require 'dfid-transition/transform/countries'

module DfidTransition
  module Patch
    module GovukContentSchemas
      class Countries < Base
        include DfidTransition::Transform::Countries

        def mutate_schema
          dfid_properties['country'] = {
            'type' => 'array',
            'items' => {
              'type' => 'string',
              'enum' => country_identifiers
            }
          }
        end

      private

        def theme_identifiers
          countries_query.solutions.map do |solution|
            parameterize(solution[:name].to_s)
          end
        end
      end
    end
  end
end
