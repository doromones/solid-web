# frozen_string_literal: true

require "rails"

module SolidWebUi
  module Cable
    class Engine < ::Rails::Engine
      isolate_namespace SolidWebUi::Cable

      config.paths["config/routes.rb"] = [ "lib/solid_web_ui/cable/routes.rb" ]
    end
  end
end
