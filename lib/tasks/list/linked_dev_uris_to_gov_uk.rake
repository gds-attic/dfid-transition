require 'dfid-transition/extract/query/abstracts_with_linked_development'
require 'dfid-transition/extract/query/outputs_by_uri'
require 'dfid-transition/transform/document'
require 'dfid-transition/services'
require 'nokogiri'

namespace :list do

  def linked_development_urls(abstract)
    fragment = Nokogiri::HTML.fragment(
      Html.unescape_three_times(
        Html.fix_encoding_errors(abstract)
      )
    )

    fragment.css('a').select { |a| a['href'] =~ /linked-development/ }.map do |a|
      a['href']
    end.uniq
  end

  def canonicalize(linked_development_url)
    match = linked_development_url.match(
      %r{http://linked-development.org/r4d/(?<type>output|project)/(?<id>[0-9]+?)/?(?:default\.aspx)?/?$}i
    )

    "http://linked-development.org/r4d/#{match[:type]}/#{match[:id]}/"
  end

  desc 'list a Ruby hash of canonicalized LD URIs to new gov.uk URLs to STDOUT'
  task :linked_dev_uris_to_gov_uk do
    Html = DfidTransition::Transform::Html

    query = DfidTransition::Extract::Query::AbstractsWithLinkedDevelopment.new

    urls = query.solutions.each_with_object([]) do |solution, urls|
      linked_development_urls(solution[:abstract].to_s).each do |linked_development_url|
        urls << canonicalize(linked_development_url)
      end
    end.uniq


    referenced_outputs = DfidTransition::Extract::Query::OutputsByUri.new(output_uris: urls, method: :post)

    puts '{'
    referenced_outputs.solutions.each do |solution|
      doc = DfidTransition::Transform::Document.new(solution)
      doc.disambiguate! if DfidTransition::Services.slug_collision_index.collides?(doc.slug)
      puts "  'http://linked-development.org/r4d/output/#{doc.original_id}/' => 'https://gov.uk#{doc.base_path}',"
    end
    puts '}'
  end

  desc 'list the URIs of things that use LD links'
  task :abstracts_referencing_ld do
    query = DfidTransition::Extract::Query::AbstractsWithLinkedDevelopment.new

    query.solutions.each do |solution|
      puts solution[:abstract].to_s
      puts "\n*********************************************************************\n"

    end
  end
end
