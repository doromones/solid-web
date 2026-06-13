# frozen_string_literal: true

require "rails"
require "solid_web_ui"
require "solid_cable"

module SolidCableWeb
  class Engine < ::Rails::Engine
    isolate_namespace SolidCableWeb
  end
end
