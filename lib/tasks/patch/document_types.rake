require 'dfid-transition/patch/rummager/document_types'

namespace :patch do
  desc 'Patch the DFID schema with document types from the R4D SKOS'
  task :types do
    DfidTransition::Patch::Rummager::DocumentTypes.new.run
  end
end
