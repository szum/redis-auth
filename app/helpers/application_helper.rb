module ApplicationHelper
  def redis
    Redis.current
  end
end
