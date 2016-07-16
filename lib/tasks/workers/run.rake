namespace :workers do
  desc 'Start all the workers referenced in dfid-transition/workers.rb'
  task :run do
    exec('bundle exec sidekiq -C ./config/sidekiq.yml')
  end
end
