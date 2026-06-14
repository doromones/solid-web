# frozen_string_literal: true

require "solid_cache"

module SolidWebUi
  # Mountable dashboard for Solid Cache. Part of the solid_web_ui gem; mount its
  # engine independently: `mount SolidWebUi::Cache::Engine => "/admin/cache"`.
  module Cache
    extend SolidWebUi::Configurable

    config.page_title = "Solid Cache"

    setting :enable_clear, default: true
    setting :enable_create, default: true
    setting :enable_edit, default: true
    setting :enable_delete, default: true
  end
end

require "solid_web_ui/cache/engine"
