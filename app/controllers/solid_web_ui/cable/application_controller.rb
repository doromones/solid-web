# frozen_string_literal: true

module SolidWebUi::Cable
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidWebUi::Cable.config.base_controller_class)
    layout -> { SolidWebUi::Cable.config.layout }
    helper SolidWebUi::ComponentHelper

    private

    def trimmable_scope
      SolidCable::Message.where(created_at: ...SolidWebUi::Cable.config.retention.ago)
    end
  end
end
