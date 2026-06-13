# frozen_string_literal: true

module SolidWebUi::Cache
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidWebUi::Cache.config.base_controller_class)
    layout "solid_web_ui"
    helper SolidWebUi::ComponentHelper

    private

    def per_page
      SolidWebUi::Cache.config.per_page
    end
  end
end
