#!/usr/bin/env ruby

##
# WARNING: Don't run this unless you're just sketching out how
#          you'd like things to look, end-to-end. It's intended
#          to be a quick sketchpad to show what's required at each
#          step, and is being factored out into co-operating classes
#
$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string'
require 'dfid-transition/transform/document'
require 'govuk/presenters/search'
require 'dfid-transition/services'
require 'dfid-transition/extract/query/outputs'

ENDPOINT = 'http://linked-development.org/sparql'

publishing_api = DfidTransition::Services.publishing_api
rummager       = DfidTransition::Services.rummager

class ContentIdByBasePath < Struct.new(:publishing_api)
  # Only looks up for state: 'published'
  def [](base_path)
    publishing_api.lookup_content_id(base_path: base_path)
  end
end

output_solutions = DfidTransition::Extract::Query::Outputs.new.solutions

content_id_mappings = ContentIdByBasePath.new(publishing_api)

output_solutions.each do |output_solution|
  doc = DfidTransition::Transform::Document.new(output_solution)

  existing_draft_content_id = content_id_mappings[doc.base_path]
  doc.content_id = existing_draft_content_id if existing_draft_content_id

  update_type = existing_draft_content_id ? 'republish' : 'major'

  should_discard_draft = true
  begin
    publishing_api.put_content(doc.content_id, doc.to_json)
    publishing_api.publish(doc.content_id, update_type)
    puts "Published #{doc.title} at "\
         "http://www.dev.gov.uk/dfid-research-outputs/#{doc.original_id}"
    should_discard_draft = false
  rescue GdsApi::HTTPUnprocessableEntity => e
    $stderr.puts "WARN: #{e.inspect}"
    should_discard_draft = false
  ensure
    # Don't leave us in a state where we could 422
    publishing_api.discard_draft(doc.content_id) if should_discard_draft
  end

  rummager.add_document(
    'dfid_research_output',
    doc.base_path,
    Govuk::Presenters::Search.new(doc).to_json,
  )
end
