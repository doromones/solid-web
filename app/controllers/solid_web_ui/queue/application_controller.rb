# frozen_string_literal: true

module SolidWebUi::Queue
  # Inherits from the host-configured controller (default ActionController::Base)
  # so host authentication/authorization applies. Resolved lazily at autoload
  # time, after host initializers have set `base_controller_class`.
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidWebUi::Queue.config.base_controller_class)
    layout -> { SolidWebUi::Queue.config.layout }
    helper SolidWebUi::ComponentHelper

    private

    def per_page
      SolidWebUi::Queue.config.per_page
    end
  end
end
