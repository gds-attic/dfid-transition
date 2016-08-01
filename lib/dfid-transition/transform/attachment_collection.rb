require 'dfid-transition/transform/attachment'

module DfidTransition
  module Transform
    class AttachmentCollection
      include Enumerable

      attr_reader :attachments

      def initialize(attachments)
        @attachments = attachments
      end

      def each
        @attachments.each { |attachment| yield attachment }
      end

      def downloads
        @attachments.select(&:hosted_at_r4d?)
      end

      ##
      # Sets the title of attachment(s) where able
      def normalize!(document_title)
        case
        when count == 1
          @attachments.first.title = document_title if @attachments.one?
        when count == 2 && one_r4d_one_bumph?
          @attachments = @attachments.reject(&:external_link?)
          @attachments.first.title = document_title
        end
        self
      end

      def one_r4d_one_bumph?
        @attachments.detect { |a| a.original_url.host =~ /dx\.doi\.org/ } &&
          Set.new(@attachments.map(&:hosted_at_r4d?)) == Set.new([false, true])
      end

      def self.from_uris(uris)
        raise ArgumentError, "Expected space-separated string, got #{uris.class}" unless uris.is_a?(String)

        attachments = uris.split(' ').map { |uri| Attachment.new(uri) }

        AttachmentCollection.new(attachments)
      end
    end
  end
end
