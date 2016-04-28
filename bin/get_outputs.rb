require 'sparql/client'
require 'redis-namespace'
require 'securerandom'
require 'ostruct'
require 'active_support/core_ext/time'
require 'govspeak'

NAMESPACE = 'r4d'
redis_config = {
  host: '127.0.0.1',
  port: 6379
}

ENDPOINT = 'http://linked-development.org/sparql'
QUERY = <<-SPARQL
  PREFIX dcterms: <http://purl.org/dc/terms/>
  PREFIX ont: <http://purl.org/ontology/bibo/>
  PREFIX geo: <http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/>

  SELECT DISTINCT ?output ?countryCode ?title ?abstract
  WHERE {
      ?output a ont:Article ;
              dcterms:title ?title ;
              dcterms:abstract ?abstract .

      OPTIONAL {
        ?output dcterms:coverage ?country .
        ?country a geo:self_governing ;
                 geo:codeISO2 ?countryCode.
      }
  }
  LIMIT 100
SPARQL

client = SPARQL::Client.new(ENDPOINT, method: :get)
puts client.url

results = client.query(QUERY, content_type: SPARQL::Client::RESULT_JSON)

DOCUMENT_QUEUE = 'to_process'
redis = Redis::Namespace.new(NAMESPACE, redis_config)

module GovspeakPresenter
  class << self
    def present(govspeak)
      [
        { content_type: "text/govspeak", content: govspeak },
        {
          content_type: "text/html",
          content: Govspeak::Document.new(govspeak).to_html
        }
      ]
    end
  end
end

class Document
  attr_accessor :solution, :content_id

  def initialize(solution)
    self.solution = solution
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
    solution[:abstract].to_s.strip
  end

  def public_updated_at
    Time.now
  end

  def details
    {
      body: GovspeakPresenter.present(summary),
      # metadata: metadata,
      # change_history: change_history
    }

    # Attachments would be handled here
    #.tap do |details_hash|
    #  details_hash[:attachments] = attachments if document.attachments
    #end
  end

  def to_json
    {
      content_id: content_id,
      original_id: original_id,
      base_path: base_path,
      title: title,
      description: summary,
      document_type: 'dfid_research_output',
      schema_name: "specialist_document",
      publishing_app: "specialist-publisher",
      rendering_app: "specialist-frontend",
      locale: "en",
      phase: 'live',
      public_updated_at: public_updated_at,
      details: details,
      routes: [
        {
          path: base_path,
          type: "exact",
        }
      ],
      redirects: [],
      update_type: 'minor',
    }
  end
end

current_output = nil

results.each do |output|
  document = Document.new(output)

  if seeing_for_first_time(current_output)

  end
  json = JSON.pretty_generate(document.to_json)
  puts json
  redis.multi do
    redis.set document.original_id_redis_key, document.content_id
    redis.rpush DOCUMENT_QUEUE, json
  end
end

