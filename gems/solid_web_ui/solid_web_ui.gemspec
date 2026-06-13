# frozen_string_literal: true

require_relative "lib/solid_web_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "solid_web_ui"
  spec.version     = SolidWebUi::VERSION
  spec.authors     = [ "Anton Radushev" ]
  spec.summary     = "Shared design system and base engine for the Solid* web UIs."
  spec.description = "Layout, ViewComponents, theming (design tokens) and a dry-configurable base " \
                     "shared by solid_queue_web, solid_cache_web and solid_cable_web."
  spec.homepage    = "https://github.com/doromones/solid-web"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir["lib/**/*", "app/**/*", "config/**/*", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "dry-configurable", ">= 1.0"
  spec.add_dependency "propshaft", ">= 1.0"
end
