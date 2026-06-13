# frozen_string_literal: true

require "solid_queue"

module SolidWebUi
  # Mountable dashboard for Solid Queue. Part of the solid_web_ui gem; mount its
  # engine independently: `mount SolidWebUi::Queue::Engine => "/admin/queue"`.
  module Queue
    extend SolidWebUi::Configurable

    config.page_title = "Solid Queue"

    setting :enable_retry, default: true
    setting :enable_discard, default: true
    setting :enable_pause, default: true
  end
end

require "solid_web_ui/queue/engine"
