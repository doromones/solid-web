# frozen_string_literal: true

require "solid_web_ui"
require "solid_queue_web/version"
require "solid_queue_web/engine"

module SolidQueueWeb
  extend SolidWebUi::Configurable

  # Default dashboard title; the shared base also gives us base_controller_class,
  # per_page and time_zone.
  config.page_title = "Solid Queue"

  # Destructive actions, each guardable by the host.
  setting :enable_retry, default: true
  setting :enable_discard, default: true
  setting :enable_pause, default: true
end
