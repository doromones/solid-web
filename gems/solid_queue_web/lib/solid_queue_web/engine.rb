# frozen_string_literal: true

require "rails"
require "solid_web_ui"
require "solid_queue"

module SolidQueueWeb
  class Engine < ::Rails::Engine
    isolate_namespace SolidQueueWeb
  end
end
