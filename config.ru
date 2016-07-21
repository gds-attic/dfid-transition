require_relative 'config/initializers/sidekiq'

require 'sidekiq/web'
run Sidekiq::Web
