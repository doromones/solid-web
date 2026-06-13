# frozen_string_literal: true

module SolidCableWeb
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidCableWeb.config.base_controller_class)
    layout "solid_web_ui"

    private

    def trimmable_scope
      SolidCable::Message.where(created_at: ...SolidCableWeb.config.retention.ago)
    end
  end
end
