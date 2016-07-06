require 'dfid-transition/extract/query/themes'
require 'dfid-transition/transform/themes'
require 'dfid-transition/patch/specialist_publisher/base'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Themes < Base
        include DfidTransition::Transform::Themes

        def mutate_schema
          theme_facet['allowed_values'] =
            transform_to_label_value(themes_query.solutions)
        end

      private

        def themes_query
          @themes_query ||= DfidTransition::Extract::Query::Themes.new
        end

        def theme_facet
          facet('theme')
        end
      end
    end
  end
end
