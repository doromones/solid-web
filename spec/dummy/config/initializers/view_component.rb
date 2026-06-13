# frozen_string_literal: true

# Register the shared gem's ViewComponent previews so they are browsable in
# Lookbook and renderable via render_preview. Set on the live previews registry
# (read by both Lookbook and the preview template lookup) after ViewComponent's
# railtie has installed its defaults.
previews_path = File.expand_path("../../../solid_web_ui/components/previews", __dir__)

ViewComponent::Base.previews.paths |= [ previews_path ]
ViewComponent::Base.previews.enabled = true
ViewComponent::Base.previews.default_layout = "solid_web_ui"
