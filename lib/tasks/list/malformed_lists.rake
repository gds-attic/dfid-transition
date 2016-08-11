require 'dfid-transition/extract/query/abstracts_with_lists'
require 'dfid-transition/transform/document'
require 'dfid-transition/transform/malformed_list_tester'
require 'dfid-transition/services'

namespace :list do
  Html = DfidTransition::Transform::Html

  def final_url(doc, env: 'development')
    host = case env
           when 'integration' then 'www-origin.integration.publishing.service.gov.uk'
           when 'staging' then 'www-origin.staging.publishing.service.gov.uk'
           when 'development' then 'www.dev.gov.uk'
           else 'gov.uk'
           end
    "http#{env == 'development' ? '' : 's'}://#{host}#{doc.base_path}"
  end

  desc 'List abstracts with malformed list'
  task :malformed_list, [:limit, :env] do |_t, args|
    env = args[:env]

    query = DfidTransition::Extract::Query::AbstractsWithLists.new(limit: args[:limit])

    malformed_list_tests = query.solutions.map do |solution|
      DfidTransition::Transform::MalformedListTester.new(solution)
    end

    malformed_list_solutions = malformed_list_tests.select(&:has_malformed_list?).map(&:solution)

    malformed_list_docs = malformed_list_solutions.map do |solution|
      DfidTransition::Transform::Document.new(solution).tap do |doc|
        doc.disambiguate! if DfidTransition::Services.slug_collision_index.collides?(doc.slug)
      end
    end

    malformed_list_docs.each do |doc|
      puts "# #{final_url(doc, env: env)}"

      puts "\n## Raw"

      puts doc.solution[:abstract].to_s

      puts "\n## HTML"

      abstract_html = Html.unescape_three_times(
        Html.fix_encoding_errors(
          doc.solution[:abstract].to_s
        )
      )
      puts abstract_html

      puts "\n## As markdown"
      puts doc.abstract
      puts "\n**********************************************************\n"
    end

    puts "\n<ul> total: #{malformed_list_tests.count(&:has_malformed_ul?)}"
    puts "\n<ol> total: #{malformed_list_tests.count(&:has_malformed_ol?)}"
  end
end
