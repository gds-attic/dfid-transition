require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/services'
require 'dfid-transition/transform/mappings'

namespace :list do
  desc 'List transition mappings for old URLs'
  task :mappings, [:limit] do |_t, args|
    output_query = DfidTransition::Extract::Query::Outputs.new(limit: args[:limit])

    mappings = DfidTransition::Transform::Mappings.new(
      DfidTransition::Services.attachment_index,
      output_query.solutions
    )

    mappings.dump_csv
  end
end
