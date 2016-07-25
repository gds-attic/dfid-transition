require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/enqueue/outputs'
require 'dfid-transition/services'

namespace :enqueue do
  desc 'Load DFID attachments with attachment URIs from the SPARQL endpoint'
  task :outputs, [:limit] do |_t, args|
    logger = Logger.new(STDERR)

    query = DfidTransition::Extract::Query::Outputs.new(limit: args[:limit])

    logger.info "Requesting #{query.limit} outputs"
    output_solutions = query.solutions

    outputs_loader =
      DfidTransition::Enqueue::Outputs.new(output_solutions, logger: logger)

    outputs_loader.run
  end
end
