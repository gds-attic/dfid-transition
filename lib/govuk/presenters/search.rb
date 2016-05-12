require 'active_support/core_ext/string'

module Govuk
  module Presenters
    class Search
      def initialize(document)
        @document = document
      end

      def indexable_content
        document.body
      end

      def to_json
        {
          title: document.title,
          description: document.summary,
          link: document.base_path,
          indexable_content: indexable_content,
          organisations: ['department-for-international-development'],
          public_timestamp: document.public_updated_at.to_datetime.rfc3339,
        }.merge(document.format_specific_metadata).reject { |_k, v| v.blank? }
      end

      private

      attr_reader :document
    end
  end
end
