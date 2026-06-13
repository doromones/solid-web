# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::StatusBadgeComponent, type: :component do
  it "renders the label" do
    render_inline(described_class.new(label: "ready"))
    expect(page).to have_css(".swui-badge", text: "ready")
  end

  it "maps a known status to a tone class" do
    render_inline(described_class.new(label: "failed", status: :failed))
    expect(page).to have_css(".swui-badge--danger")
  end

  it "falls back to a neutral tone for unknown status" do
    render_inline(described_class.new(label: "weird", status: :weird))
    expect(page).to have_css(".swui-badge--neutral")
  end
end
