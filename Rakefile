$LOAD_PATH.unshift(File.expand_path('lib', File.dirname(__FILE__)))

require 'rake'
require 'rake/testtask'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => [:spec, :lint]

Dir.glob('lib/tasks/**/*.rake').each { |r| import r }
