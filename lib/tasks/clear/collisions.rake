require 'dfid-transition/services/slug_collision_index'

namespace :clear do
  desc 'Clear collisions'
  task :collisions do
    DfidTransition::Services.slug_collision_index.clear
  end
end


