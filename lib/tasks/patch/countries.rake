require 'dfid-transition/patch/countries'

namespace :patch do
  desc 'Get countries from DFID'
  task :countries do
    DfidTransition::Patch::Countries.new.run!
  end
end
