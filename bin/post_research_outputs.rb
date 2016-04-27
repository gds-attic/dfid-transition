#!/usr/bin/env ruby
require 'gds_api/publishing_api_v2'
require 'pry'

content_id = "7ff519c9-f315-490e-8ccc-1f01e80f0cf1"
path = '/dfid-research-outputs/abc'
document = {
  :content_id=>content_id,
  :base_path=>path,
  :title=>"ooo",
  :description=>"ooo",
  :document_type=>"dfid_research_output",
  :schema_name=>"specialist_document",
  :publishing_app=>"specialist-publisher",
  :rendering_app=>"specialist-frontend",
  :locale=>"en",
  :phase=>"live",
  :public_updated_at=>"2016-04-21T16:19:09+00:00",

  :details=>
   {:body=>
     [{:content_type=>"text/govspeak", :content=>"ooo"},
      {:content_type=>"text/html", :content=>"<p>ooo</p>\n"}],
    :metadata=>{:country=>"UK", :document_type=>"dfid_research_output"},
    :change_history=>[{:public_timestamp=>"2016-04-21T16:19:09+00:00", :note=>"First published."}]},
  :routes=>[{:path=>path, :type=>"exact"}],
  :redirects=>[],
  :update_type=>"major",
  :organisations => ['b994552-7644-404d-a770-a2fe659c661f']
}

links = {
  content_id: content_id,
  links: {
    organisations: document[:organisations]
  },
}

publishing_api = GdsApi::PublishingApiV2.new(
  Plek.new.find('publishing-api'),
  bearer_token: 'example',
)

begin
  binding.pry
  result = publishing_api.put_content(content_id, document)
  links_result = publishing_api.patch_links(content_id, links)
rescue GdsApi::HTTPUnprocessableEntity => e
  binding.pry
  error_message = e.error_details.dig('error', 'fields', 'content_item').first
  document_state = error_message.match(/state=(?<state>.+?), /)[:state]

  case document_state
  when 'draft' then
    publishing_api.discard_draft(content_id)
    retry
  else
  end

end
pp result

binding.pry
