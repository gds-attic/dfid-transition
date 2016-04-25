#!/usr/bin/env ruby

require 'rest-client'
require 'json'

JSON_ENDPOINT = "http://linked-development.org/sparql.json"

get_countries = <<-SPARQL
  PREFIX dbp: <http://dbpedia.org/property/>
  PREFIX terms: <http://purl.org/dc/terms/>
  PREFIX bibo: <http://purl.org/ontology/bibo/>
  PREFIX geo: <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>

  SELECT DISTINCT ?countryCode ?countryName
  WHERE {
    ?output
      a bibo:Article ;
      terms:coverage ?country .
    ?country
      geo:codeDBPediaID ?countryName ;
      geo:codeISO2 ?countryCode
  }
  ORDER BY ?countryCode
SPARQL

results_str = RestClient.get JSON_ENDPOINT, params: { query: get_countries }

results_hash = JSON.parse results_str
source_array = results_hash.dig "results", "bindings"

label_value_pairs = source_array.inject([]) do |dest_array, result|
  dest_array << {
    label: result.dig('countryName', 'value'),
    value: result.dig('countryCode', 'value')
  }
  dest_array
end

puts JSON.pretty_generate(label_value_pairs)
