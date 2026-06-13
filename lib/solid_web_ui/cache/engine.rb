# frozen_string_literal: true

require "rails"

module SolidWebUi
  module Cache
    class Engine < ::Rails::Engine
      isolate_namespace SolidWebUi::Cache

      config.paths["config/routes.rb"] = [ "lib/solid_web_ui/cache/routes.rb" ]
    end
  end
end
