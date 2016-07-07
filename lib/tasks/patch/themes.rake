require 'dfid-transition/patch/specialist_publisher/themes'
require 'dfid-transition/patch/rummager/themes'
require 'dfid-transition/patch/govuk_content_schemas/themes'

namespace :patch do
  desc 'Patch the DFID schema with themes from the R4D SKOS'
  task :themes do
    DfidTransition::Patch::SpecialistPublisher::Themes.new.run
    DfidTransition::Patch::Rummager::Themes.new.run
    DfidTransition::Patch::GovukContentSchemas::Themes.new.run
  end
end
