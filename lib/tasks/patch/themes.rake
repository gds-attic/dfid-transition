require 'dfid-transition/patch/themes'

namespace :patch do
  desc 'Patch the DFID schema with themes from the R4D SKOS'
  task :themes do
    DfidTransition::Patch::Themes.new.run
  end
end
