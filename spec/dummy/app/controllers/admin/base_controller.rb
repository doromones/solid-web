# frozen_string_literal: true

# Stand-in for a host's authenticated admin controller. The three engines are
# configured (config/initializers/solid_web.rb) to inherit from this, proving
# that host authentication flows through `base_controller_class`. Auth is gated
# by a class flag so the integration spec can toggle it without affecting the
# other specs (default: off).
module Admin
  class BaseController < ActionController::Base
    cattr_accessor :auth_required, default: false

    before_action :require_admin!

    private

    def require_admin!
      head :unauthorized if self.class.auth_required && request.headers["X-Admin"].blank?
    end
  end
end
