module Middleware
  class ShardSwitcher
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      request.path =~ /.*stores\/(\d+).*/
      store_id = $1

      if store_id
        store = Store.find(store_id.to_i)
        ShardRecord.connected_to(shard: store.shard) do
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end
  end
end
