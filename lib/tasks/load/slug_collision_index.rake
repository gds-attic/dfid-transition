require 'dfid-transition/extract/query/duplicate_titles'
require 'dfid-transition/load/slug_collisions'
require 'dfid-transition/services'

namespace :load do
  desc 'Load the slug collision index'
  task :collisions do
    logger   = Logger.new(STDERR)
    services = DfidTransition::Services

    collisions_query = DfidTransition::Extract::Query::DuplicateTitles.new

    loader = DfidTransition::Load::SlugCollisions.new(
      services.slug_collision_index,
      collisions_query.solutions,
      logger: logger
    )
    loader.run
  end
end
