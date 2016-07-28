require 'dfid-transition/services/stats'

namespace :show do
  desc 'Show stats'
  task :stats do
    stats = DfidTransition::Services.stats

    puts stats.to_s
  end
end
