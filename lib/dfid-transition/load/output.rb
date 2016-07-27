require 'sidekiq/worker'
require 'rdf/query'
require 'dfid-transition/services'
require 'dfid-transition/transform/document'
require 'dfid-transition/transform/output_serializer'
require 'govuk/presenters/search'

module DfidTransition
  module Load
    class Output
      include Sidekiq::Worker

      attr_accessor :doc

      def perform(solution_hash)
        solutions = DfidTransition::Transform::OutputSerializer.deserialize(solution_hash)
        solution = solutions.first

        self.doc = DfidTransition::Transform::Document.new(solution)

        unless all_assets_available?
          logger.warn("One or more assets missing for #{doc.original_url}")
          return
        end

        publish
      end

      def all_assets_available?
        doc.downloads.all? do |attachment|
          existing_attachment_details = attachment_index.get(attachment.original_url.to_s)
          attachment.details_from_index(existing_attachment_details)
        end
      end

      def publish(check_for_existing: true)
        existing_content_id = nil

        if check_for_existing
          existing_content_id = publishing_api.lookup_content_id(base_path: doc.base_path)
          doc.content_id = existing_content_id if existing_content_id
        end

        update_type = existing_content_id ? 'republish' : 'major'

        begin
          begin
            publishing_api.put_content(doc.content_id, doc.to_json)
          rescue GdsApi::HTTPUnprocessableEntity => e
            match = e.message.match(/content_id=(?<content_id>.+)([^a-z0-9-])?/)
            if match
              doc.content_id = match[:content_id]
              publish(check_for_existing: false)
            else
              logger.error(e)
            end
            return
          end

          publishing_api.patch_links(doc.content_id, doc.links)
          publishing_api.publish(doc.content_id, update_type)
          logger.info "Published #{doc.title} at "\
              "http://www.dev.gov.uk#{doc.base_path}"
        rescue => e
          logger.error(e)
        end

        rummager.add_document(
          'dfid_research_output',
          doc.base_path,
          Govuk::Presenters::Search.new(doc).to_json,
        )
      end

    private

      def attachment_index
        Services.attachment_index
      end

      def rummager
        Services.rummager
      end

      def publishing_api
        Services.publishing_api
      end
    end
  end
end
