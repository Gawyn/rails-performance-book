require_relative "boot"

require "rails/all"
require_relative '../app/middleware/datadog_middleware'
require_relative '../app/middleware/shard_switcher'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moviestore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.middleware.use Middleware::ShardSwitcher
    config.middleware.use Middleware::DatadogMiddleware

    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    Dir["./components/*"].each do |path|
      next unless File.directory?(path)
      component = path.split("/").last

      config.autoload_paths += Dir[Rails.root.join('components', component, 'app', '**')]
      config.autoload_paths += Dir[Rails.root.join('components', component, 'public')]
    end
  end
end
