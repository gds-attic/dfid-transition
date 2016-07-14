require 'govuk/registers/country'

module DfidTransition
  module Transform
    module Countries
      # Yugoslavia, Czechoslovakia, USSR, East Germany
      # Any country with an end date
      INACTIVE = lambda do |_iso2_code, country|
        country['end-date']
      end

      # Tied to one output
      MISSING = {
        'CK' => {
          'country' => 'CK',
          'name' => 'Cook Islands'
        }
      }.freeze

      # Facet-friendly names
      RENAME = lambda do |countries|
        countries['GM']['name'] = 'Gambia, The'
        countries['BS']['name'] = 'Bahamas, The'
      end

    private

      def alphabetically_sorted_countries
        countries.sort_by { |_, details| details['name'] }
      end

      def countries
        @countries ||=
          Govuk::Registers::Country.countries.reject(&INACTIVE).merge(MISSING).tap(&RENAME)
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
