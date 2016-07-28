require 'dfid-transition/services/stats'

namespace :stats do
  desc 'Show stats'
  task :show do
    stats = DfidTransition::Services::Stats.new

    puts stats.to_s
  end
end
