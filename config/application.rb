require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Regulation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.api_only = true
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
      g.factory_bot false
      g.factory_bot dir: 'spec/factories'
    end

    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    config.i18n.default_locale = :zh_CN

    config.autoload_paths << Rails.root.join('lib')

    config.api_only = false
    # for grape
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden

    # same as YAML.load_file(Rails.root.join('config', 'redis.yml'))[Rails.env]
    %w(redis mailer).each do |key|
      config.send(:"#{key}=", config_for(key.to_sym).deep_symbolize_keys!)
    end

    # config.redis = config_for(:redis).deep_symbolize_keys!
    config.cache_store = :redis_store, config.redis

    # Active Job
    config.active_job.queue_adapter = :sidekiq
  end
end
