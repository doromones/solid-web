# frozen_string_literal: true

module SolidQueueWeb
  # Inherits from the host-configured controller (default ActionController::Base)
  # so host authentication/authorization applies. Resolved lazily at autoload
  # time, after host initializers have set `base_controller_class`.
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidQueueWeb.config.base_controller_class)
    layout "solid_web_ui"

    private

    def per_page
      SolidQueueWeb.config.per_page
    end
  end
end
