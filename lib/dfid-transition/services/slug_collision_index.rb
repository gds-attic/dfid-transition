require 'dfid-transition/services'

module DfidTransition
  module Services
    ##
    # Concerns: allows us to look up slug collisions by original_url
    #
    class SlugCollisionIndex
      attr_reader :redis

      def initialize(redis)
        @redis = redis
      end

      SLUG_COLLISIONS_SET = 'slug-collisions'.freeze

      def put(slug)
        @redis.sadd(SLUG_COLLISIONS_SET, slug)
      end

      def collides?(slug)
        @redis.sismember(SLUG_COLLISIONS_SET, slug)
      end

      def clear
        @redis.del(SLUG_COLLISIONS_SET)
      end
    end
  end
end
