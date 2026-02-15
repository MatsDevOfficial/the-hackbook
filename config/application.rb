require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
if Rails.env.production?
  Bundler.require(*Rails.groups, :production)
  # Exclude solid_* gems and mission_control from auto-loading in production serverless
  # to prevent eagerness issues or missing tables.
  # We manually require what we need if necessary, but these are mostly for background workers/action cable
  # which we aren't using in the serverless context (using async/pusher instead if needed).
else
  Bundler.require(*Rails.groups)
end

module HcRailsStarter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Enable Rack::Attack middleware
    config.middleware.use Rack::Attack

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
