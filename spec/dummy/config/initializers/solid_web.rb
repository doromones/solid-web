# frozen_string_literal: true

# Host wiring for the three dashboards. Runs at boot, before any request, so the
# engines' ApplicationControllers resolve their parent from these values.
SolidWebUi::Queue.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cache.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cable.config.base_controller_class = "Admin::BaseController"
