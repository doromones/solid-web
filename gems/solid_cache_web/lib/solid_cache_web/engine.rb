# frozen_string_literal: true

require "rails"
require "solid_web_ui"
require "solid_cache"

module SolidCacheWeb
  class Engine < ::Rails::Engine
    isolate_namespace SolidCacheWeb
  end
end
