require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/enqueue/attachments'
require 'dfid-transition/services'

namespace :enqueue do
  desc 'Load DFID attachments with attachment URIs from the SPARQL endpoint'
  task :attachments, [:limit] do |_t, args|
    logger = Logger.new(STDERR)

    query = DfidTransition::Extract::Query::Outputs.new(limit: args[:limit])

    logger.info "Requesting #{query.limit} documents' worth of attachments"
    output_solutions = query.solutions

    attachments_loader = DfidTransition::Enqueue::Attachments.new(
      DfidTransition::Services.asset_manager,
      output_solutions,
      logger: logger
    )

    attachments_loader.run
  end
end
