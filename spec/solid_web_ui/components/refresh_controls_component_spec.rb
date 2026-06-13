# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::RefreshControlsComponent, type: :component do
  it "renders a frequency select, a status slot and a manual refresh button" do
    render_inline(described_class.new(frame_id: "swui-refresh-frame"))

    expect(page).to have_css(".swui-refresh[data-frame='swui-refresh-frame']")
    expect(page).to have_css("select[data-swui-refresh-select]")
    expect(page).to have_css("[data-swui-refresh-status]")
    expect(page).to have_css("button[data-swui-refresh-now]")
  end

  it "offers the configured intervals and pre-selects the default" do
    render_inline(described_class.new(frame_id: "f", default_interval: 5, intervals: [ 0, 5, 30 ]))

    expect(page).to have_css("option[value='0']", text: "Off")
    expect(page).to have_css("option[value='5']", text: "5s")
    expect(page).to have_css("option[value='30']", text: "30s")
    expect(page).to have_css("option[value='5'][selected]")
  end

  it "falls back to the global config when no overrides are given" do
    render_inline(described_class.new(frame_id: "f"))

    expect(page).to have_css("[data-interval='#{SolidWebUi.config.refresh_interval}']")
    expect(page).to have_css("option[value='#{SolidWebUi.config.refresh_interval}'][selected]")
  end
end
