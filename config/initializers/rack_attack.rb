Rack::Attack.throttle("requests by ip", limit: 1, period: 100) do |request|
  request.ip
end

Rack::Attack.throttle('limit access to the timeline', limit: 100, period: 60) do |req|
  if req.path =~ /^api\/v1\/customers\/\d+\/timeline/
    req.env['rack.session']['warden.user.user.key']&.first&.first
  end
end
