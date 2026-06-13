# frozen_string_literal: true

require "rails"

module SolidWebUi
  module Queue
    class Engine < ::Rails::Engine
      isolate_namespace SolidWebUi::Queue

      # All sub-engines share the gem root, so point each at its own routes file
      # (the default config/routes.rb would collide across the parts).
      config.paths["config/routes.rb"] = [ "lib/solid_web_ui/queue/routes.rb" ]
    end
  end
end
