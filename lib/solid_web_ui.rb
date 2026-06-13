# frozen_string_literal: true

require "dry/configurable"

require "solid_web_ui/version"
require "solid_web_ui/configurable"
require "solid_web_ui/theme"
require "solid_web_ui/paginator"
require "solid_web_ui/head_helper"
require "solid_web_ui/engine"

module SolidWebUi
  extend Dry::Configurable

  # Theming / asset settings shared across all three dashboards.
  setting :theme, default: {}             # token overrides, e.g. { color_primary: "#7c3aed" }
  setting :color_scheme, default: "auto"  # "auto" | "light" | "dark"
  setting :stylesheet, default: true      # false → don't link the bundled CSS (host takes over)
  setting :extra_stylesheets, default: [] # extra Propshaft stylesheet names to link after ours
  setting :javascript, default: true      # false → don't link the bundled live-refresh JS

  # Live auto-refresh of the dashboards (polling a turbo-frame). The default is
  # the pre-selected interval (seconds; 0 disables); refresh_intervals are the
  # choices offered in the dashboard's frequency <select>.
  setting :refresh_interval, default: 10                  # seconds; 0 = off
  setting :refresh_intervals, default: [ 0, 2, 5, 10, 30, 60 ].freeze

  # Resolve a configured controller class name to a class. Called lazily when a
  # web engine's ApplicationController is autoloaded, so host initializers have
  # already run and `base_controller_class` points at the host's auth controller.
  def self.resolve_base_controller(class_name)
    class_name.to_s.constantize
  end
end

# Mountable dashboard parts. Each defines its own isolated engine
# (SolidWebUi::Queue::Engine, ::Cache::Engine, ::Cable::Engine) that the host
# mounts independently.
require "solid_web_ui/queue"
require "solid_web_ui/cache"
require "solid_web_ui/cable"
