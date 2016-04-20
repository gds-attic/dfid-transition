require 'rest-client'
require 'json'

module DfidTransition
  module Patch
    SPECIALIST_PUBLISHER_DIR = 'specialist-publisher-rebuild'

    class Countries
      REGISTER_JSON = 'https://country.register.gov.uk/records.json'
      attr_reader :location

      def initialize(location = nil)
        @location = location || relative_schema_location
      end

      def run!
        File.exists?(location) or raise Errno::ENOENT.new(location)

        country_facet['allowed_values'] = transform_to_label_value(register_countries)

        File.open(location, 'w+') do |target|
          target.write(JSON.pretty_generate(schema_hash))
        end
      end

      private

      ##
      # Get register-format country data
      def register_countries
        params = { 'page-size' => 100, 'page-index' => 1 }
        done = false

        existing_countries = -> (country) do
          country.dig('entry', 'end-date').nil?
        end

        [].tap do |results|
          while !done
            body = RestClient.get(REGISTER_JSON, { params: params })
            countries_page = JSON.parse(body)

            results.concat(countries_page.select(&existing_countries))

            done = (countries_page.length < params['page-size'])
            params['page-index'] += 1
          end
        end
      end

      def transform_to_label_value(query_results)
        query_results.map do |result|
          {
            label: result.dig('entry', 'country'),
            value: result.dig('entry', 'name')
          }
        end
      end

      def country_facet
        schema_hash['facets'].find { |f| f['key'] == 'country' } or
          raise KeyError.new('No country facet found')
      end

      def schema_hash
        @schema_hash ||= JSON.parse(File.read(location))
      end

      ##
      # Used when a location is not given; default to specialist publisher's DFID
      # schema location relative to this repo's directory
      def relative_schema_location
        File.expand_path(
          File.join(
            Dir.pwd, '..', SPECIALIST_PUBLISHER_DIR, 'lib/documents/schemas/dfid_research_outputs.json'
          )
        )
      end
    end
  end
end
