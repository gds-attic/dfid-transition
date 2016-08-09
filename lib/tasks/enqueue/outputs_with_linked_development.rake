require 'dfid-transition/extract/query/outputs_with_linked_development'
require 'dfid-transition/enqueue/outputs'

namespace :enqueue do
  desc 'Enqueue outputs that have bad links to linked development'
  task :outputs_with_linked_development do
    logger = Logger.new(STDERR)

    bad_outputs = DfidTransition::Extract::Query::OutputsWithLinkedDevelopment.new

    logger.info "Requesting outputs referencing linked development"

    outputs_loader = DfidTransition::Enqueue::Outputs.new(bad_outputs.solutions, logger: logger)
    outputs_loader.run
  end
end
