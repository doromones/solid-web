# frozen_string_literal: true

require "solid_web_ui"
require "solid_cable_web/version"
require "solid_cable_web/engine"

module SolidCableWeb
  extend SolidWebUi::Configurable

  config.page_title = "Solid Cable"

  # Trimming deletes old messages; host can disable it and tune the retention
  # window used to decide what counts as "old".
  setting :enable_trim, default: true
  setting :retention, default: 1.day
end
