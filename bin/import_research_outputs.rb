#!/usr/bin/env ruby

##
# WARNING: Don't run this unless you're just sketching out how
#          you'd like things to look, end-to-end. It's intended
#          to be a quick sketchpad to show what's required at each
#          step, and will be factored out into co-operating classes
#

require 'sparql/client'
require 'securerandom'
require 'govspeak'
require 'gds_api/publishing_api_v2'
require 'gds_api/rummager'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string'

ENDPOINT = 'http://linked-development.org/sparql'

module GovspeakPresenter
  class << self
    def present(govspeak)
      [
        { content_type: "text/govspeak", content: govspeak },
        {
          content_type: "text/html",
          content:      Govspeak::Document.new(govspeak).to_html
        }
      ]
    end
  end
end

class SearchPresenter
  delegate :title, to: :document

  def initialize(document, publishing_api)
    @document = document
    @publishing_api = publishing_api
  end

  def to_json
    {
      title: document.title,
      description: document.summary,
      link: document.base_path,
      indexable_content: indexable_content,
      organisations: organisation_slugs,
      public_timestamp: document.public_updated_at.to_datetime.rfc3339,
    }.merge(document.format_specific_metadata).reject { |_k, v| v.blank? }
  end

  def indexable_content
    document.body.last[:content]
  end

  def organisation_slugs
    response = publishing_api.get_content_items(document_type: "organisation", fields: [:content_id, :base_path])

    orgs = response.results.select { |o| document.organisations.include?(o["content_id"]) }
    orgs.map { |o| o["base_path"].gsub("/government/organisations/", "") }.map { |o| o.gsub("/courts-tribunals/", "") }
  end

  private

  attr_reader :document, :publishing_api
end


class Document
  attr_accessor :solution, :content_id

  def initialize(solution)
    self.solution   = solution
    self.content_id = SecureRandom.uuid
  end

  def original_id
    uri.to_s.match(/\/(?<id>[0-9]+?)\//)[:id]
  end

  def original_id_redis_key
    "output-#{original_id}"
  end

  def uri
    solution[:output]
  end

  def base_path
    "/dfid-research-outputs/#{original_id}"
  end

  def title
    solution[:title].to_s.strip
  end

  def summary
    solution[:summary].to_s.strip
  end

  def public_updated_at
    Time.new("2016-04-21T16:19:09+00:00")# Time.now
  end

  def metadata
    { document_type: "dfid_research_output" }
  end

  def details
    {
      body: GovspeakPresenter.present(summary),
      metadata: metadata
      # change_history: change_history
    }

    # Attachments would be handled here
    #.tap do |details_hash|
    #  details_hash[:attachments] = attachments if document.attachments
    #end
  end

  def organisations
    ['b994552-7644-404d-a770-a2fe659c661f']
  end

  def countries
    solution[:countryCodes].to_s.split(' ')
  end

  def links
    {
      content_id: content_id,
      links: {
        organisations: organisations
      },
    }
  end

  def body
    details[:body]
  end

  def format_specific_metadata
    { country: countries }
  end

  def to_json
    {
      content_id:        content_id,
      base_path:         base_path,
      title:             title,
      description:       summary,
      document_type:     'dfid_research_output',
      schema_name:       "specialist_document",
      publishing_app:    "specialist-publisher",
      rendering_app:     "specialist-frontend",
      locale:            "en",
      phase:             'live',
      public_updated_at: public_updated_at,
      details:           details,
      routes:            [
                           {
                             path: base_path,
                             type: "exact",
                           }
                         ],
      redirects:         [],
      update_type:       'minor',
      organisations:     organisations
    }
  end
end

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

SELECT DISTINCT ?output  ?summary
                (GROUP_CONCAT(?titleSource) AS ?title)
                (GROUP_CONCAT(?codeISO2) AS ?countryCodes)
WHERE {
  ?output a ont:Article ;
          dcterms:title ?titleSource ;
          dcterms:abstract ?summary ;
          dcterms:date ?date ;
          dcterms:coverage ?country .
  ?country a geo:self_governing ;
           geo:codeISO2 ?codeISO2 .
} GROUP BY ?output ?summary
ORDER BY DESC(?date)
LIMIT 100
SPARQL

client = SPARQL::Client.new(ENDPOINT, method: :get)
output_solutions = client.query(QUERY, content_type: SPARQL::Client::RESULT_JSON)

content_id_mappings = ContentIdByBasePath.new(publishing_api)

output_solutions.each do |output_solution|
  doc = Document.new(output_solution)
  existing_draft_content_id = content_id_mappings[doc.base_path]
  doc.content_id = existing_draft_content_id if existing_draft_content_id

  publishing_api.put_content(doc.content_id, doc.to_json)
  publishing_api.publish(doc.content_id, 'major')
  puts "Published research output at "\
       "http://specialist-frontend.dev.gov.uk/dfid-research-outputs/#{doc.original_id}"

  indexable_document = SearchPresenter.new(doc, publishing_api)
  rummager_request = rummager.add_document(
    'dfid_research_output',
    doc.base_path,
    indexable_document.to_json,
  )
end
