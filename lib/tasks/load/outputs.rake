require 'dfid-transition/extract/query/outputs'
require 'dfid-transition/load/outputs'
require 'dfid-transition/services'

namespace :load do
  desc 'Load DFID outputs with results from the SPARQL endpoint'
  task :outputs do
    module DfidTransition
      output_solutions = Extract::Query::Outputs.new.solutions
      loader = Load::Outputs.new(
        Services.publishing_api,
        Services.rummager,
        Services.asset_manager,
        Services.attachment_index,
        output_solutions
      )
      loader.run
    end
  end
end
