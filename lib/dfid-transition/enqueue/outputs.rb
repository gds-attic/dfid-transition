require_relative '../../../config/initializers/sidekiq'

require 'dfid-transition/transform/output_serializer'
require 'dfid-transition/load/output'
require 'logger'

module DfidTransition
  module Enqueue
    class Outputs
      attr_reader :logger
      attr_accessor :solutions

      def initialize(solutions, logger: Logger.new(STDERR))
        self.solutions = solutions

        @logger = logger
      end

      def run
        solutions.each do |solution|
          serialized_solution = DfidTransition::Transform::OutputSerializer.serialize(solution)
          DfidTransition::Load::Output.perform_async(serialized_solution)
        end
        logger.info "Enqueued #{solutions.count} outputs for publishing"
      end
    end
  end
end
