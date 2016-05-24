require 'dfid-transition/extract/query/base_path_dupes'

def path_from_title(title)
  "/dfid-research-outputs/#{title.parameterize}"
end

namespace :list do
  desc 'List base_paths that would have a duplicate'
  task :base_path_dupes do
    base_paths = Hash.new { |hash, key| hash[key] = [] }

    DfidTransition::Extract::Query::BasePathDupes.new.solutions.each do |solution|
      base_path = path_from_title(solution[:title].to_s)
      base_paths[base_path] << solution[:output].to_s
    end

    base_path_dupes = base_paths.select { |_path, urls| urls.length > 1 }
    puts "#{base_path_dupes.length} duplicates\n---------------------------------"

    base_path_dupes.each do |path, urls|
      puts "\n######{path}\n* #{urls.join("\n* ")}\n"
    end
  end
end
