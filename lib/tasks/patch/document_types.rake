require 'dfid-transition/patch/rummager/document_types'
require 'dfid-transition/patch/specialist_publisher/document_types'
require 'dfid-transition/patch/govuk_content_schemas/document_types'

namespace :patch do
  desc 'Patch the DFID schema with document types from the R4D SKOS'
  task :types do
    DfidTransition::Patch::SpecialistPublisher::DocumentTypes.new.run
    DfidTransition::Patch::Rummager::DocumentTypes.new.run
    DfidTransition::Patch::GovukContentSchemas::DocumentTypes.new.run
  end
end
