# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Embedding a dashboard in a host layout", type: :request do
  around do |example|
    original = SolidWebUi::Queue.config.layout
    SolidWebUi::Queue.config.layout = "embedded"
    example.run
    SolidWebUi::Queue.config.layout = original
  end

  it "renders the dashboard inside the host layout, keeping the host chrome" do
    get "/admin/solid_queue"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("HOST CHROME")    # host layout preserved
    expect(response.body).to include("solid-web-ui")   # dashboard still scoped/themed
    expect(response.body).to include("Ready")          # dashboard content rendered
  end
end
