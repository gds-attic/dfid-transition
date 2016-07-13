require 'govuk/registers/country'

module DfidTransition
  module Transform
    module Countries
    private

      def alphabetically_sorted_countries
        countries.sort_by { |_, details| details['name'] }
      end

      def countries
        Govuk::Registers::Country.countries
      end

      def transform_to_label_value(countries)
        countries.map do |country_code, country_details|
          {
            value: country_code,
            label: country_details['name']
          }
        end
      end

      def country_identifiers
        alphabetically_sorted_countries.map { |country_code, _| country_code }
      end
    end
  end
end
