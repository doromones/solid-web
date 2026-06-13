# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::ComponentHelper, type: :helper do
  it "renders a stat card via swui_stat_card" do
    html = helper.swui_stat_card(label: "Failed", value: 12, tone: :danger)
    expect(html).to include("swui-card--danger")
    expect(html).to include("Failed")
    expect(html).to include("12")
  end

  it "renders a linked stat card" do
    html = helper.swui_stat_card(label: "Jobs", value: 3, href: "/x")
    expect(html).to include("href=\"/x\"")
  end

  it "renders a status badge via swui_status_badge" do
    html = helper.swui_status_badge(label: "failed", status: :failed)
    expect(html).to include("swui-badge--danger")
    expect(html).to include("failed")
  end
end
