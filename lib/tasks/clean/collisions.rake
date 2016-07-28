require 'dfid-transition/services/slug_collision_index'

namespace :clean do
  desc 'Clean collisions'
  task :collisions do
    DfidTransition::Services.slug_collision_index.clean
  end
end


