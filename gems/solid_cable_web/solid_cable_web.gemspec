# frozen_string_literal: true

require_relative "lib/solid_cable_web/version"

Gem::Specification.new do |spec|
  spec.name        = "solid_cable_web"
  spec.version     = SolidCableWeb::VERSION
  spec.authors     = [ "Anton Radushev" ]
  spec.summary     = "Mountable web dashboard for Solid Cable."
  spec.description = "A Rails mountable engine that surfaces Solid Cable channel activity, message " \
                     "volume and retention maintenance in a styled dashboard."
  spec.homepage    = "https://github.com/doromones/solid-web"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "solid_cable", ">= 1.0"
  spec.add_dependency "solid_web_ui", SolidCableWeb::VERSION
end
