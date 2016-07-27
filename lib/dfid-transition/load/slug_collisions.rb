require 'dfid-transition/transform/document'

module DfidTransition
  module Load
    class SlugCollisions
      def initialize(slug_collision_index, solutions, logger: STDERR)
        @slug_collision_index = slug_collision_index
        @solutions = solutions
        @logger = logger
      end

      def run
        loaded = 0
        @solutions.each do |solution|
          slug = DfidTransition::Transform::Document.new(solution).slug
          @slug_collision_index.put(slug)
          loaded += 1
        end

        @logger.info "#{loaded} collisions loaded"
      end
    end
  end
end
