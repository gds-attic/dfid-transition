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
      SLUG_COLLISIONS_KEY_PREFIX = 'slug-collisions:for:'.freeze

      def collides?(slug)
        false
      end
    private

      def slug_collision_key(original_url)
        "attachment:#{original_url}"
      end
    end
  end
end
