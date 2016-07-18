require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/load/attachments'
require 'dfid-transition/services'

namespace :load do
  desc 'Load DFID attachments with attachment URIs from the SPARQL endpoint'
  task :attachments do
    module DfidTransition
      output_solutions = Extract::Query::Outputs.new.solutions

      attachments_loader = Load::Attachments.new(
        Services.asset_manager,
        output_solutions
      )

      attachments_loader.run
    end
  end
end
