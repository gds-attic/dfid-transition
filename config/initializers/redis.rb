require 'redis-namespace'

def _redis_config
  @redis_config ||= begin
    redis_config_hash = YAML.load_file('config/redis.yml').symbolize_keys

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
