$LOAD_PATH.unshift(File.expand_path('../../..', File.dirname(__FILE__), ))

require 'sidekiq'
require 'dfid-transition/services'
require 'dfid-transition/transform/attachment'

module DfidTransition
  module Extract
    module Download
      class Attachment
        include Sidekiq::Worker

        def perform(url)
          logger.info("Skipping: #{url}") && return if attachment_index.get(url)

          attachment = DfidTransition::Transform::Attachment.new(url)

          asset_response = attachment.save_to(asset_manager)
          attachment_index.put(url, asset_response)
        end

      private

        def asset_manager
          Services.asset_manager
        end

        def attachment_index
          Services.attachment_index
        end
      end
    end
  end
end
