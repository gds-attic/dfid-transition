require 'dfid-transition/patch/base'
require 'rest-client'
require 'nokogiri'

module DfidTransition
  R4D_ADVANCED_SEARCH = "http://r4d.dfid.gov.uk/Search/SearchResearchDatabase.aspx"

  module Patch
    class Regions < Base

      def mutate_schema
        html = RestClient.get R4D_ADVANCED_SEARCH

        region_facet['allowed_values'] =
          transform_to_label_value(html).reject { |lv| lv[:value] == "==" }
      end

    private

      def region_facet
        facet('region')
      end

      def transform_to_label_value(html)
        doc = Nokogiri::HTML(html)
        options = doc.css('#ContentPlaceHolderMainDiv_ddlRegionList option')
        options.map do |option|
          {
            label: option.xpath('./text()'),
            value: option['value']
          }
        end
      end
    end
  end
end
