#!/usr/bin/env ruby

##
# WARNING: Don't run this unless you're just sketching out how
#          you'd like things to look, end-to-end. It's intended
#          to be a quick sketchpad to show what's required at each
#          step, and is being factored out into co-operating classes
#
$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

require 'sparql/client'
require 'gds_api/publishing_api_v2'
require 'gds_api/rummager'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string'
require 'dfid-transition/transform/document'
require 'govuk/presenters/search'

ENDPOINT = 'http://linked-development.org/sparql'

publishing_api = GdsApi::PublishingApiV2.new(
  Plek.new.find('publishing-api'),
  bearer_token: 'example',
)

rummager = GdsApi::Rummager.new(Plek.new.find('search'))

class ContentIdByBasePath < Struct.new(:publishing_api)
  def [](base_path)
    publishing_api.lookup_content_id(base_path: base_path)
  end
end

QUERY = <<-SPARQL
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX ont:     <http://purl.org/ontology/bibo/>
PREFIX geo:     <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>

SELECT DISTINCT ?output ?date ?abstract
                (GROUP_CONCAT(DISTINCT(?titleSource)) AS ?title)
                (GROUP_CONCAT(DISTINCT(?codeISO2)) AS ?countryCodes)
WHERE {
  ?output a ont:Article ;
          dcterms:title ?titleSource ;
          dcterms:abstract ?abstract ;
          dcterms:date ?date ;
          dcterms:coverage ?country .
  ?country a geo:self_governing ;
           geo:codeISO2 ?codeISO2 .
} GROUP BY ?output ?date ?abstract
ORDER BY DESC(?date)
LIMIT 10
SPARQL

client = SPARQL::Client.new(ENDPOINT, method: :get)
output_solutions = client.query(QUERY, content_type: SPARQL::Client::RESULT_JSON)

content_id_mappings = ContentIdByBasePath.new(publishing_api)

output_solutions.each do |output_solution|
  doc = DfidTransition::Transform::Document.new(output_solution)

  existing_draft_content_id = content_id_mappings[doc.base_path]
  doc.content_id = existing_draft_content_id if existing_draft_content_id

  update_type = existing_draft_content_id ? 'republish' : 'major'

  publishing_api.put_content(doc.content_id, doc.to_json)
  publishing_api.publish(doc.content_id, update_type)
  puts "Published #{doc.title} at "\
       "http://specialist-frontend.dev.gov.uk/dfid-research-outputs/#{doc.original_id}"

  rummager.add_document(
    'dfid_research_output',
    doc.base_path,
    Govuk::Presenters::Search.new(doc).to_json,
  )
end
