require_relative '../../../config/initializers/sidekiq'

require 'dfid-transition/transform/document'
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
        documents.each do |doc|
          DfidTransition::Load::Output.perform_async(doc.solution.to_h)
        end
        logger.info "Enqueued #{documents.count} outputs for publishing"
      end

    private

      def documents
        @documents ||=
          solutions.map { |solution| DfidTransition::Transform::Document.new(solution) }
      end
    end
  end
end
