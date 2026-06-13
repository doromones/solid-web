# frozen_string_literal: true

require_relative "lib/solid_queue_web/version"

Gem::Specification.new do |spec|
  spec.name        = "solid_queue_web"
  spec.version     = SolidQueueWeb::VERSION
  spec.authors     = [ "Anton Radushev" ]
  spec.summary     = "Mountable web dashboard for Solid Queue."
  spec.description = "A Rails mountable engine that surfaces Solid Queue jobs, queues, failed " \
                     "executions, processes and recurring tasks in a styled dashboard."
  spec.homepage    = "https://github.com/doromones/solid-web"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "solid_queue", ">= 1.0"
  spec.add_dependency "solid_web_ui", SolidQueueWeb::VERSION
end
