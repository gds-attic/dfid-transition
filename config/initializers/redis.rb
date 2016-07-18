require 'redis-namespace'

def _redis_config
  @redis_config ||= begin
    redis_config_hash = {
      host: ENV["REDIS_HOST"] || "127.0.0.1",
      port: ENV["REDIS_PORT"] || 6379,
      namespace: ENV["REDIS_NAMESPACE"] || "dfid-transition",
    }

    namespace = redis_config_hash[:namespace]

    {
      url: "redis://#{redis_config_hash[:host]}:#{redis_config_hash[:port]}/0",
      namespace: namespace
    }
  end
end

def _namespaced_redis
  Redis::Namespace.new(
    _redis_config[:namespace],
    redis: Redis.new(url: _redis_config[:url])
  )
end
