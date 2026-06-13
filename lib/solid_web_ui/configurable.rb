# frozen_string_literal: true

require "dry/configurable"

module SolidWebUi
  # Shared dry-configurable base for the three web engines. Each engine does
  # `extend SolidWebUi::Configurable` and then adds its own feature-flag settings
  # (enable_retry, enable_clear, enable_trim, …). Centralizes the settings every
  # dashboard needs: which controller to inherit (host auth), page size, time zone
  # and the page title.
  module Configurable
    def self.extended(base)
      base.extend Dry::Configurable
      base.setting :base_controller_class, default: "ActionController::Base"
      base.setting :per_page, default: 25
      base.setting :time_zone, default: "UTC"
      base.setting :page_title, default: base.respond_to?(:name) ? base.name : "Solid Web"
      # Which layout the dashboards render in. Default is the gem's standalone,
      # full-page layout. Point it at a host layout (e.g. "admin") to render the
      # dashboards inside the host's chrome (sidebar/header). The host layout must
      # then include `<%= solid_web_ui_head_tags %>` and reference its own routes
      # via `main_app.` (so they resolve from the isolated engine's context).
      base.setting :layout, default: "solid_web_ui"
    end
  end
end
