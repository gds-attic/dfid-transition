require 'dfid-transition/patch/specialist_publisher/countries'

namespace :patch do
  desc 'Patch the DFID schema with countries from the GOV.UK register'
  task :countries do
    DfidTransition::Patch::SpecialistPublisher::Countries.new.run
  end
end
