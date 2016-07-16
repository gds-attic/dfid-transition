require 'sidekiq'
require 'sidekiq/api'

Sidekiq.configure_client do |config|
  config.redis = {
    :namespace => 'dfid-transition-workers',
    :size => 5
  }
end
