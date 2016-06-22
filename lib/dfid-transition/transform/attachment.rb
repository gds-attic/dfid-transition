require 'uri'

module DfidTransition
  module Transform
    class Attachment
      def initialize(original_url)
        @original_url = URI(original_url)
        raise ArgumentError, "expected a URL, got #{original_url}" unless @original_url.is_a?(URI::HTTP)
      end

      def hosted_at_r4d?
        @original_url.host == 'r4d.dfid.gov.uk'
      end
    end
  end
end
