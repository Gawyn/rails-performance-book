module Middleware
  class DatadogMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      request.path =~ /.*stores\/(\d+).*/
      store_id = $1

      Datadog::Tracing.active_span.set_tag("store_id", store_id) if store_id
      @app.call(env)
    end
  end
end
