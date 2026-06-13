# frozen_string_literal: true

require_relative "boot"

require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "propshaft"

Bundler.require(*Rails.groups)

# The four gems under test (also required by Bundler.require, listed here for clarity/order).
require "solid_web_ui"
require "solid_queue_web"
require "solid_cache_web"
require "solid_cable_web"

module Dummy
  class Application < Rails::Application
    config.load_defaults 8.1
    config.eager_load = false
    config.enable_reloading = false
    config.secret_key_base = "dummy-secret-key-base-for-tests"
    config.logger = Logger.new(IO::NULL)
    config.active_support.report_deprecations = false
  end
end
