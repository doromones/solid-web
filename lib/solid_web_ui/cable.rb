# frozen_string_literal: true

require "solid_cable"

module SolidWebUi
  # Mountable dashboard for Solid Cable. Part of the solid_web_ui gem; mount its
  # engine independently: `mount SolidWebUi::Cable::Engine => "/admin/cable"`.
  module Cable
    extend SolidWebUi::Configurable

    config.page_title = "Solid Cable"

    setting :enable_trim, default: true
    setting :retention, default: 1.day
  end
end

require "solid_web_ui/cable/engine"
