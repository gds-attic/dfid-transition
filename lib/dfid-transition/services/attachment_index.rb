require 'dfid-transition/services'

module DfidTransition
  module Services
    ##
    # Concerns: allows us to look up assets from their original DFID URLs
    #
    class AttachmentIndex
      attr_reader :redis

      def initialize(redis)
        @redis = redis
      end

      def get(original_url)
        attachment_status = redis.get(attachment_key(original_url)) || (return nil)

        JSON.parse(attachment_status)
      end

      KNOWN_ATTACHMENTS_KEY = 'known-attachments'.freeze

      def put(original_url, asset_response)
        redis.multi do
          redis.set(attachment_key(original_url), present(original_url, asset_response))
          redis.sadd(KNOWN_ATTACHMENTS_KEY, original_url)
        end
      end

    private

      def attachment_key(original_url)
        "attachment:#{original_url}"
      end

      def present(original_url, asset_response)
        JSON.generate(
          original_url:      original_url,
          asset_manager_url: asset_response.id,
          file_url:          asset_response.file_url
        )
      end
    end
  end
end
