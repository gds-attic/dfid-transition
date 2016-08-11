require 'dfid-transition/extract/query/abstracts_with_lists'
require 'dfid-transition/transform/malformed_list_tester'
require 'dfid-transition/enqueue/outputs'

namespace :enqueue do
  desc 'Enqueue outputs that have lists that might be malformed'
  task :outputs_with_malformed_lists do
    logger = Logger.new(STDERR)

    outputs_with_lists = DfidTransition::Extract::Query::AbstractsWithLists.new.solutions
    bad_outputs = outputs_with_lists.to_a.select do |output|
      DfidTransition::Transform::MalformedListTester.new(output).has_malformed_list?
    end

    logger.info "Requesting outputs with lists"

    outputs_loader = DfidTransition::Enqueue::Outputs.new(bad_outputs, logger: logger)
    outputs_loader.run
  end
end
