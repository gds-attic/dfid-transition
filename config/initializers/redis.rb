require 'redis-namespace'

def _namespaced_redis
  Redis::Namespace.new(
    'dfid-transition',
    redis: Redis.new(url: "redis://127.0.0.1:6379/0")
  )
end
