# frozen_string_literal: true

# Host wiring for the three dashboards. Runs at boot, before any request, so the
# engines' ApplicationControllers resolve their parent from these values.
SolidQueueWeb.config.base_controller_class = "Admin::BaseController"
SolidCacheWeb.config.base_controller_class = "Admin::BaseController"
SolidCableWeb.config.base_controller_class = "Admin::BaseController"
