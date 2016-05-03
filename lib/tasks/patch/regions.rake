require 'dfid-transition/patch/specialist_publisher/regions'
require 'dfid-transition/patch/rummager/regions'

namespace :patch do
  desc 'Patch the DFID schema with regions from the SPARQL endpoint'
  task :regions do
    DfidTransition::Patch::SpecialistPublisher::Regions.new.run
    DfidTransition::Patch::Rummager::Regions.new.run
  end
end
