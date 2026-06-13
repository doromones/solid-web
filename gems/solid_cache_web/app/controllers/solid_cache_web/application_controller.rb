# frozen_string_literal: true

module SolidCacheWeb
  class ApplicationController < SolidWebUi.resolve_base_controller(SolidCacheWeb.config.base_controller_class)
    layout "solid_web_ui"
    helper SolidWebUi::ComponentHelper

    private

    def per_page
      SolidCacheWeb.config.per_page
    end
  end
end
