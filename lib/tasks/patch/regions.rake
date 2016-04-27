require 'dfid-transition/patch/specialist_publisher/regions'

namespace :patch do
  desc 'Patch the DFID schema with regions from the SPARQL endpoint'
  task :regions do
    DfidTransition::Patch::SpecialistPublisher::Regions.new.run
  end
end
