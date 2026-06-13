# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cross-engine integration", type: :request do
  ROOTS = {
    "Solid Queue" => "/admin/solid_queue",
    "Solid Cache" => "/admin/solid_cache",
    "Solid Cable" => "/admin/solid_cable"
  }.freeze

  it "mounts all three engines under the shared design" do
    ROOTS.each do |title, path|
      get path

      expect(response).to have_http_status(:ok), "#{path} did not return 200"
      expect(response.body).to include("solid-web-ui")  # shared layout wrapper
      expect(response.body).to include("solid_web_ui")  # shared bundled stylesheet
      expect(response.body).to include(title)           # each engine's own title
    end
  end

  describe "host authentication via base_controller_class" do
    before { Admin::BaseController.auth_required = true }
    after { Admin::BaseController.auth_required = false }

    it "blocks unauthenticated requests through the inherited controller" do
      get "/admin/solid_queue"
      expect(response).to have_http_status(:unauthorized)
    end

    it "allows authenticated requests" do
      get "/admin/solid_queue", headers: { "X-Admin" => "1" }
      expect(response).to have_http_status(:ok)
    end

    it "applies the same auth to every engine" do
      get "/admin/solid_cache"
      expect(response).to have_http_status(:unauthorized)
      get "/admin/solid_cable"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
