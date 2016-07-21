require_relative '../../../config/initializers/sidekiq'

require 'dfid-transition/transform/document'
require 'dfid-transition/extract/download/attachment'
require 'govuk/presenters/search'
require 'logger'

module DfidTransition
  module Load
    class Attachments
      attr_reader :logger
      attr_accessor :asset_manager, :solutions

      def initialize(asset_manager, solutions, logger: Logger.new(STDERR))
        self.asset_manager = asset_manager
        self.solutions = solutions

        @logger = logger
      end

      def run
        attachments = 0
        documents.each do |doc|
          doc.downloads.each do |attachment|
            DfidTransition::Extract::Download::Attachment.perform_async(attachment.original_url)
            attachments += 1
          end
        end
        logger.info "Enqueued #{attachments} attachments for download/upload to asset-manager"
      end

    private

      def documents
        @documents ||=
          solutions.map { |solution| DfidTransition::Transform::Document.new(solution) }
      end
    end
  end
end
