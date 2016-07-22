require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/load/outputs'
require 'dfid-transition/services'

namespace :load do
  desc 'Load DFID outputs with results from the SPARQL endpoint'
  task :outputs, [:limit] do |_t, args|
    logger   = Logger.new(STDERR)
    services = DfidTransition::Services

    outputs  = DfidTransition::Extract::Query::Outputs.new(limit: args[:limit])

    loader = DfidTransition::Load::Outputs.new(
      services.publishing_api,
      services.rummager,
      services.asset_manager,
      services.attachment_index,
      outputs.solutions,
      logger: logger
    )
    loader.run
  end
end
