# frozen_string_literal: true

require "rails"
require "view_component"

module SolidWebUi
  # Not isolated on purpose: this engine is a shared design library. Keeping its
  # app/views, app/components and app/assets on the global lookup paths lets the
  # three web engines (queue/cache/cable) resolve the shared layout, components
  # and the single precompiled stylesheet without any manual view-path wiring.
  class Engine < ::Rails::Engine
  end
end
