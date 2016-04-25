require 'dfid-transition/patch/regions'

namespace :patch do
  desc 'Patch the DFID schema with regions from the SPARQL endpoint'
  task :regions do
    DfidTransition::Patch::Regions.new.run
  end
end
