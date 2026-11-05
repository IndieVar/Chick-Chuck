# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChickChuck
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    config.exceptions_app = lambda { |env|
      ErrorsController.action(:show).call(env)
    }

    # Crawler detect
    config.middleware.use Rack::CrawlerDetect

    # Anatalitycs
    config.after_initialize do
      require 'patches/active_analytics'
    end

    # ActiveJob adapter
    config.active_job.queue_adapter = :sidekiq

    # TimeZone
    config.time_zone = 'Asia/Jerusalem'

    # I18n
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.i18n.available_locales = %i[en ru he]
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Active storage
    config.active_storage.replace_on_assign_to_many = false

    # Email
    config.action_mailer.asset_host = if Rails.env.production?
                                        'http://chick-chuck.com'
                                      else
                                        'http://localhost:3000'
                                      end
  end
end
