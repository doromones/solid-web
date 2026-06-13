# frozen_string_literal: true

require_relative "lib/solid_web_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "solid_web_ui"
  spec.version     = SolidWebUi::VERSION
  spec.authors     = [ "Anton Radushev" ]
  spec.summary     = "Web dashboards for Solid Queue, Solid Cache and Solid Cable."
  spec.description = "A single gem with three independently mountable Rails engines " \
                     "(SolidWebUi::Queue/Cache/Cable::Engine) sharing one design system: " \
                     "ViewComponents, a layout, design-token theming and a dry-configurable base."
  spec.homepage    = "https://github.com/doromones/solid-web"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir["lib/**/*", "app/**/*", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "rails", ">= 8.0"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "dry-configurable", ">= 1.0"
  spec.add_dependency "propshaft", ">= 1.0"
  spec.add_dependency "solid_queue", ">= 1.0"
  spec.add_dependency "solid_cache", ">= 1.0"
  spec.add_dependency "solid_cable", ">= 1.0"
end
