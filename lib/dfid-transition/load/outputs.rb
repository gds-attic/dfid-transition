require 'dfid-transition/transform/document'
require 'govuk/presenters/search'
require 'logger'

module DfidTransition
  module Load
    class Outputs
      attr_reader :logger
      attr_accessor :publishing_api, :rummager, :asset_manager,
                    :attachment_index, :solutions

      def initialize(
        publishing_api, rummager, asset_manager,
        attachment_index, solutions, logger: Logger.new(STDERR)
      )
        self.publishing_api    = publishing_api
        self.rummager          = rummager
        self.asset_manager     = asset_manager
        self.attachment_index  = attachment_index
        self.solutions         = solutions

        @logger = logger
      end

      def run
        documents.each(&:async_download_attachments)
        documents.each { |doc| publish(doc) }
      end

    private

      def documents
        @documents ||=
          solutions.map { |solution| DfidTransition::Transform::Document.new(solution) }
      end

      def publish(doc, check_for_existing: true)
        existing_content_id = nil

        if check_for_existing
          existing_content_id = publishing_api.lookup_content_id(base_path: doc.base_path)
          doc.content_id = existing_content_id if existing_content_id
        end

        update_type = existing_content_id ? 'republish' : 'major'

        wait_for_upload_to_asset_manager(doc.downloads)

        begin
          begin
            publishing_api.put_content(doc.content_id, doc.to_json)
          rescue GdsApi::HTTPUnprocessableEntity => e
            match = e.message.match(/content_id=(?<content_id>.+)([^a-z0-9-])?/)
            if match
              doc.content_id = match[:content_id]
              publish(doc, check_for_existing: false)
            else
              logger.error(e)
            end
            return
          end

          publishing_api.patch_links(doc.content_id, doc.links)
          publishing_api.publish(doc.content_id, update_type)
          logger.info "Published #{doc.title} at "\
              "http://www.dev.gov.uk/dfid-research-outputs/#{doc.original_id}"
        rescue => e
          logger.error(e)
        end

        rummager.add_document(
          'dfid_research_output',
          doc.base_path,
          Govuk::Presenters::Search.new(doc).to_json,
        )
      end

      def wait_for_upload_to_asset_manager(downloads)
        downloads.each do |attachment|
          existing_attachment_details = attachment_index.get(attachment.original_url.to_s)
          if existing_attachment_details
            attachment.details_from_index(existing_attachment_details)
          else
            download(attachment)
          end
        end
      end

      def download(attachment)
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
  end
end
