require 'dfid-transition/patch/countries'

namespace :patch do
  desc 'Patch the DFID schema with countries from the GOV.UK register'
  task :countries do
    DfidTransition::Patch::Countries.new.run
  end
end
