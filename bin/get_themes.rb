#!/usr/bin/env ruby

require 'rest-client'
require 'json'
require 'sparql'
require 'rdf/rdfxml'

require 'pry'

repository = RDF::Repository.load('http://r4d.dfid.gov.uk/RDF/SKOS/Themes.rdf')
sparql = SPARQL::Client.new(repository)

theme_query = <<-SPARQL
  PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>

  SELECT DISTINCT ?theme ?prefLabel
  WHERE {
    ?theme skos:inScheme <http://r4d.dfid.gov.uk/rdf/skos/Themes> ;
           skos:prefLabel ?prefLabel .
  }
SPARQL

results = sparql.query(theme_query)
results.map! do |solution|
  theme_slug = solution['theme'].to_s.sub(%r{http://.*#}, '')

  {
    label: theme_slug,
    value: solution['prefLabel'].to_s
  }
end

puts results
