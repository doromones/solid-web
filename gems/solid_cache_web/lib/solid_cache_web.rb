# frozen_string_literal: true

require "solid_web_ui"
require "solid_cache_web/version"
require "solid_cache_web/engine"

module SolidCacheWeb
  extend SolidWebUi::Configurable

  config.page_title = "Solid Cache"

  # Wiping the whole cache is destructive — host can disable it.
  setting :enable_clear, default: true
end
