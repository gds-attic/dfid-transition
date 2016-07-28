require 'dfid-transition/services'
require 'dfid-transition/services/slug_collision_index'
require 'dfid-transition/services/attachment_index'

module DfidTransition
  module Services
    class Stats
      def initialize(redis)
        @redis = redis
      end

      def collision_index_size
        @redis.smembers(SlugCollisionIndex::SLUG_COLLISIONS_SET).size
      end

      def attachment_index_size
        @redis.smembers(AttachmentIndex::KNOWN_ATTACHMENTS_KEY).size
      end

      def to_s
        "Slug collisions: #{collision_index_size}\n" \
        "Attachments: #{attachment_index_size}"
      end
    end
  end
end
