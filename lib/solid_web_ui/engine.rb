# frozen_string_literal: true

require "rails"
require "view_component"

module SolidWebUi
  # Not isolated on purpose: this engine is a shared design library. Keeping its
  # app/views, app/components and app/assets on the global lookup paths lets the
  # three web engines (queue/cache/cable) resolve the shared layout, components
  # and the single precompiled stylesheet without any manual view-path wiring.
  class Engine < ::Rails::Engine
    # Expose solid_web_ui_head_tags to every host view, so a host layout can pull
    # in the dashboards' stylesheet + theme tokens when embedding them.
    initializer "solid_web_ui.head_helper" do
      ActiveSupport.on_load(:action_view) do
        include SolidWebUi::HeadHelper
      end
    end
  end
end
