require 'dfid-transition/patch/rummager/base'
require 'govuk/registers/country'
require 'rest-client'

module DfidTransition
  module Patch
    module Rummager
      class Countries < Base
        def mutate_schema
          unless schema_hash.fetch('fields').include?('country')
            schema_hash.fetch('fields') << 'country'
          end
        end
      end
    end
  end
end
