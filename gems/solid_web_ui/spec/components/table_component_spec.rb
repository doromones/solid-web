# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::TableComponent, type: :component do
  it "renders the column headers and yielded body" do
    render_inline(described_class.new(headers: %w[Queue Size])) do
      "<tr><td>default</td><td>5</td></tr>".html_safe
    end

    expect(page).to have_css("table.swui-table")
    expect(page).to have_css("th", text: "Queue")
    expect(page).to have_css("th", text: "Size")
    expect(page).to have_css("td", text: "default")
  end

  it "renders an empty state when there is no body" do
    render_inline(described_class.new(headers: %w[Queue], empty_message: "No queues"))

    expect(page).to have_text("No queues")
  end
end
