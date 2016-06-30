require 'dfid-transition/transform/document'
require 'govuk/presenters/search'
require 'logger'

module DfidTransition
  module Load
    class Outputs
      attr_reader :logger
      attr_accessor :publishing_api, :rummager, :asset_manager, :solutions

      def initialize(publishing_api, rummager, asset_manager, solutions, logger: Logger.new(STDERR))
        self.publishing_api = publishing_api
        self.rummager       = rummager
        self.asset_manager  = asset_manager
        self.solutions      = solutions

        @logger = logger
      end

      def transform_documents
        @transform_documents =
          solutions.map { |solution| DfidTransition::Transform::Document.new(solution) }
      end

      def run
        transform_documents.each(&:async_download_attachments)
        transform_documents.each { |doc| publish(doc) }
      end

      def publish(doc)
        existing_draft_content_id = content_id_from(doc.base_path)
        doc.content_id            = existing_draft_content_id if existing_draft_content_id

        update_type = existing_draft_content_id ? 'republish' : 'major'

        wait_for_upload_to_asset_manager(doc.attachments)

        should_discard_draft = true
        begin
          publishing_api.put_content(doc.content_id, doc.to_json)
          publishing_api.patch_links(doc.content_id, doc.links)
          publishing_api.publish(doc.content_id, update_type)
          logger.info "Published #{doc.title} at "\
              "http://www.dev.gov.uk/dfid-research-outputs/#{doc.original_id}"
          should_discard_draft = false
        rescue GdsApi::HTTPUnprocessableEntity => e
          logger.warn "#{doc.original_url}: #{e}"
        rescue => e
          logger.error(e)
        ensure
          # Don't leave us in a state where we could 422
          publishing_api.discard_draft(doc.content_id) if should_discard_draft
        end

        rummager.add_document(
          'dfid_research_output',
          doc.base_path,
          Govuk::Presenters::Search.new(doc).to_json,
        )
      end

      def wait_for_upload_to_asset_manager(attachments)
        attachments.select(&:hosted_at_r4d?).each do |attachment|
          file = attachment.file # block on the value
          case attachment.file_future.state
          when :rejected
            logger.warn(attachment.file_future.reason)
          when :fulfilled
            begin
              attachment.save_to(asset_manager)
            ensure
              file.close
            end
          end
        end
      end

    private

      def content_id_from(base_path)
        publishing_api.lookup_content_id(base_path: base_path)
      end
    end
  end
end
