require 'dfid-transition/extract/query/projects'
require 'dfid-transition/services'
require 'dfid-transition/transform/mappings'

namespace :list do
  def old_url(linked_development_url)
    # e.g. http://linked-development.org/r4d/project/50112/
    match = linked_development_url.match %r{http://linked-development\.org/r4d/project/(?<id>[0-9]+?)/$}i
    "http://r4d.dfid.gov.uk/Project/#{match[:id]}/"
  end

  desc 'List projects mappings for old URLs'
  task :project_mappings, [:limit] do |_t, args|
    projects = DfidTransition::Extract::Query::Projects.new(limit: args[:limit])

    puts DfidTransition::Transform::Mappings::HEADER_ROW

    projects.solutions.each do |solution|
      puts "#{old_url(solution[:project].to_s)},TNA"
      puts "#{old_url(solution[:project].to_s)}Default.aspx,TNA"
    end
  end
end
