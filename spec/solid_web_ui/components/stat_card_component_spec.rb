# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::StatCardComponent, type: :component do
  it "renders a label and value" do
    render_inline(described_class.new(label: "Failed", value: 12))

    expect(page).to have_css(".swui-card")
    expect(page).to have_text("Failed")
    expect(page).to have_text("12")
  end

  it "applies a tone modifier class" do
    render_inline(described_class.new(label: "Failed", value: 12, tone: :danger))

    expect(page).to have_css(".swui-card--danger")
  end

  it "links the card when href is given" do
    render_inline(described_class.new(label: "Jobs", value: 3, href: "/admin/solid_queue/jobs"))

    expect(page).to have_css("a.swui-card[href='/admin/solid_queue/jobs']")
  end
end
