require 'dfid-transition/patch/patcher'
require 'json'

module DfidTransition
  module Patch
    module GovukContentSchemas
      class Base < Patcher

      private

        def relative_path
          File.expand_path(
            File.join(
              Dir.pwd,
              '..',
              'govuk-content-schemas',
              'formats/specialist_document/publisher/details.json'
            )
          )
        end
      end
    end
  end
end
