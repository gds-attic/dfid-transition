require 'dfid-transition/patch/rummager/base'
require 'govuk/registers/country'
require 'rest-client'

module DfidTransition
  module Patch
    module Rummager
      class Themes < Base
        def mutate_schema
          unless schema_hash.fetch('fields').include?('theme')
            schema_hash.fetch('fields') << 'theme'
          end
        end
      end
    end
  end
end
