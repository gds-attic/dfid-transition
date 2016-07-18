require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/services'
require 'dfid-transition/transform/mappings'

namespace :list do
  desc 'List transition mappings for old URLs'
  task :mappings do
    module DfidTransition
      output_query = Extract::Query::Outputs.new

      mappings = Transform::Mappings.new(
        Services.attachment_index,
        output_query.solutions
      )

      mappings.dump_csv
    end
  end
end
