require_relative './redis'

require 'sidekiq'
require 'sidekiq/api'

Sidekiq.configure_server do |config|
  config.redis = _redis_config
end

Sidekiq.configure_client do |config|
  config.redis = _redis_config
end
