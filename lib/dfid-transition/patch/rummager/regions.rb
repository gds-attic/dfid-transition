require 'dfid-transition/patch/rummager/base'
require 'govuk/registers/country'
require 'rest-client'

module DfidTransition
  module Patch
    module Rummager
      class Regions < Base
        def mutate_schema
          unless schema_hash.fetch('fields').include?('region')
            schema_hash.fetch('fields') << 'region'
          end
        end
      end
    end
  end
end
